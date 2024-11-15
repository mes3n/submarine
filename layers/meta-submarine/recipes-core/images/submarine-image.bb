SUMMARY = "Basic image for managing submarine"

inherit core-image

IMAGE_FEATURES += "ssh-server-dropbear"

# Networking needed for WAP
IMAGE_INSTALL:append = " \
    linux-firmware-ath9k \
    dnsmasq \
    hostapd \
"

IMAGE_FSTYPES = "wic wic.gz wic.bmap"
