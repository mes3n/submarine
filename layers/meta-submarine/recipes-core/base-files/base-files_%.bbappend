FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
    file://dnsmasq.conf \
    file://hostapd.conf \
    file://interfaces \
"

do_install:append() {
    install -m 644 ${WORKDIR}/dnsmasq.conf ${D}/${sysconfdir}/dnsmasq.conf
    install -m 644 ${WORKDIR}/hostapd.conf ${D}/${sysconfdir}/hostapd/hostapd.conf
    install -m 644 ${WORKDIR}/interfaces ${D}/${sysconfdir}/network/interfaces
}
