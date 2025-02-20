FROM ubuntu:20.04

RUN ( \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get -y upgrade && \
    apt-get -y -qq install \
        gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio \
        python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git \
        python3-jinja2 python3-subunit zstd liblz4-tool file locales libacl1 locales && \
    apt-get -y -qq install \
        tmux vim && \
    apt-get -y autoremove && apt-get clean \
)

RUN locale-gen en_US.UTF-8
