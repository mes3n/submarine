#!/bin/sh

# https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-routed-wireless-access-point

WLAN_ADAPTER="$1"
AP_IP_ADDRESS_BASE="10.10.10"

echo "adapter name is $WLAN_ADAPTER"
echo "continue (y/n): "

read answer

if [ "$answer" = "y" -o "$answer" = "Y" ]
then
    echo "starting..."
else
    exit 0
fi

sudo apt -y install hostapd dnsmasq

sudo systemctl unmask hostapd
sudo systemctl enable hostapd

echo "\n"

echo "interface $WLAN_ADAPTER
    static ip_address=$AP_IP_ADDRESS_BASE.1/24
    nohook wpa_supplicant" | sudo tee -a /etc/dhcpcd.conf
echo "\n"

sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

echo "interface=$WLAN_ADAPTER # Listening interface
dhcp-range=$AP_IP_ADDRESS_BASE.2,$AP_IP_ADDRESS_BASE.3,255.255.255.0,24h
                # Pool of IP addresses served via DHCP
domain=wlan     # Local wireless DNS domain" | sudo tee /etc/dnsmasq.conf
echo "\n"

echo "country_code=SE
interface=$WLAN_ADAPTER
ssid=submarine-wifi
hw_mode=g
channel=4
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=PleaseDr1iveMe
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP" | sudo tee /etc/hostapd/hostapd.conf
echo "\n"

echo "done. please reboot."
