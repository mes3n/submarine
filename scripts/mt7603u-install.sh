#!/bin/sh

sudo apk install git  # install git for alpineOS

# https://github.com/ChalesYu/buildroot_platform_hardware_wifi_mtk_drivers_mt7603
cd
git clone https://gitlab.com/ChalesYu/buildroot_platform_hardware_wifi_mtk_drivers_mt7603.git mt7603u
cd mt7603u
git checkout pub-test-v20220304

sudo cp conf/MT7603USTA.dat /lib/firmware/MT7603USTA.dat

### CHANGE FILE CONTENTS
sed -i 's/ARCH ?= x86_64/ARCH ?= arm64/g' Makefile

# build
make KSRC=/lib/modules/$(uname -r)/build -j4
sudo cp os/linux/mt7603usta.ko /lib/modules/$(uname -r)/kernel/drivers/net/wireless/
sudo depmod -a
sudo modprobe mt7603usta

echo 
ip a
echo

echo "Enter MAC adress: "
read MAC_ADRESS
echo
echo "Enter wlan adapter: "
read WLAN_ADAPTER

echo "MAC adress is $MAC_ADRESS"
echo "adapter name is $WLAN_ADAPTER"
echo "continue (y/n): "

read answer

if [ answer == 'y' ] || [ answer == 'Y' ]
then
    continue
else
    exit 0
fi

# https://forums.raspberrypi.com/viewtopic.php?t=198687
sudo echo 'SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="'$MAC_ADRESS'", NAME="'$WLAN_ADAPTER'"' > /etc/udev/rules.d/72-xxx.rules
