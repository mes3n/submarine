SUMMARY = "Basic image for managing submarine"

inherit core-image extrausers

IMAGE_FEATURES:remove = "debug-tweaks"

# Networking needed for WAP
IMAGE_INSTALL:append = " \
    linux-firmware-ath9k \
    dnsmasq \
    hostapd \
"

# printf "%q" $(openssl passwd -1 IngetVattenTack)
PASSWD = "\$1\$ZtO3RGsS\$GXTi6opX2RQHtpXDTfrA4/"
EXTRA_USERS_PARAMS = " \
    usermod -p '${PASSWD}' root; \
"

IMAGE_INSTALL:append = " submarine-steering"

IMAGE_FSTYPES = "wic wic.gz wic.bmap"
