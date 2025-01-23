SUMMARY = "Basic image for managing submarine"

inherit core-image

IMAGE_FEATURES += "ssh-server-dropbear"

# Networking needed for WAP
IMAGE_INSTALL:append = " \
    linux-firmware-mt7601u \
    linux-firmware-ath9k \
    dnsmasq \
    hostapd \
"

# GPIO CLI
IMAGE_INSTALL:append = " \
    libgpiod-tools \
"

IMAGE_INSTALL:append = " submarine-steering"

IMAGE_FSTYPES = "wic wic.gz wic.bmap"
