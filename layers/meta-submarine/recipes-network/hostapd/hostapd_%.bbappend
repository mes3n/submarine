FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
    file://hostapd.conf \
"

do_install:append() {
    install -m 0644 ${UNPACKDIR}/hostapd.conf ${D}${sysconfdir}/hostapd.conf
}
