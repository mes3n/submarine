LICENSE = "CLOSED"

SRC_URI = "git://github.com/mes3n/submarine-steering;protocol=https;branch=main"

PV = "1.0+git"
SRCREV = "${AUTOREV}"
PROVIDES = "submarine-steering"
DEPENDS = "libgpiod"

S = "${WORKDIR}/git"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
	file://defconfig \
	file://init \
"

inherit update-rc.d
INITSCRIPT_NAME = "steering"

FILES:${PN} += " \
	/bin/${PN} \
	${sysconfdir}/steering.conf \
	${sysconfdir}/init.d/${INITSCRIPT_NAME} \
"

EXTRA_OEMAKE = "CC='${CC}' PACKAGE='${PN}'"
TARGET_CC_ARCH += "${LDFLAGS}"

do_configure () {
	install -m 0644 ${UNPACKDIR}/defconfig ${S}/.config
}

do_compile () {
	oe_runmake "LDFLAGS=${LDFLAGS}"
}

do_install () {
	install -d ${D}${bindir} ${D}${sysconfdir} ${D}${sysconfdir}/init.d

	install -m 0755 ${S}/bin/${PN} ${D}${bindir}/${PN}
	install -m 0644 ${S}/main.conf ${D}${sysconfdir}/steering.conf

	install -m 0755 ${UNPACKDIR}/init ${D}${sysconfdir}/init.d/${INITSCRIPT_NAME}
}

