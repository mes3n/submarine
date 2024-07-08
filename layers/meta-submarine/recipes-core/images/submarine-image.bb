SUMMARY = "Basic image for managing submarine"

inherit core-image

hostname:pn-base-files = "submarine"
MOTD = "Welcome to the submarine system!"

IMAGE_FEATURES += "ssh-server-dropbear"

# Networking needed for WAP
IMAGE_INSTALL:append = " dnsmasq hostapd"
