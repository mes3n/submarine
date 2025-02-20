DOCKER_IMAGE ?= yocto-builder
DOCKER_TAG ?= $(shell cat Dockerfile | md5sum | cut -c 1-4)

TEMPLATE_DIR ?= $(CURDIR)/layers/meta-submarine/conf/templates/submarine

include .config
.config:
	touch .config

ifdef CONFIG_BITBAKE_DOWNLOADS
DOCKER_CMD_OPTIONS += -v $(CONFIG_BITBAKE_DOWNLOADS):$(CURDIR)/build/downloads
endif  # CONFIG_BITBAKE_DOWNLOADS

ifdef CONFIG_BITBAKE_SSTATE_CACHE
DOCKER_CMD_OPTIONS += -v $(CONFIG_BITBAKE_SSTATE_CACHE):$(CURDIR)/build/sstate-cache
endif  # CONFIG_BITBAKE_SSTATE_CACHE

.PHONY: docker-build-image
docker-build-image:
	@if ! docker inspect $(DOCKER_IMAGE):$(DOCKER_TAG) 2>&1 > /dev/null; then \
		docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) \
			$(CURDIR); \
	fi

DOCKER_CMD=docker run --rm --tty --interactive --net host \
	--user $(shell id -u):$(shell id -g) \
	--volume $(CURDIR):$(CURDIR):rw \
	--workdir $(CURDIR) \
	$(DOCKER_CMD_OPTIONS) \
	$(DOCKER_IMAGE):$(DOCKER_TAG)

cmd ?= bash -i
yocto-shell: docker-build-image submodules
	$(DOCKER_CMD) bash -c "TEMPLATECONF=$(TEMPLATE_DIR) \
		. layers/poky/oe-init-build-env && $(cmd)"

.PHONY: docker-clean-hash docker-clean
docker-clean-hash:
	rm -f $(CURDIR)/build/hashserve.sock

docker-clean: docker-clean-hash
	-docker rmi $(DOCKER_IMAGE):$(DOCKER_TAG)

.PHONY: submodules
submodules:
	git submodule update --init --recursive

.PHONY: clean-build clean
clean-build:
	rm -rf build

clean: docker-clean clean-build
	rm .config

# vim: ts=4
