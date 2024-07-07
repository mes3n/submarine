SUMMARY = "Basic image for managing submarine"

inherit core-image

IMAGE_FEATURES += "ssh-server-dropbear"

# Networking needed for WAP
IMAGE_INSTALL:append = " dnsmasq hostapd"
