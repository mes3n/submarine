#!/bin/sh

sudo apt install git linux-headers # Install needed packages

# https://github.com/ChalesYu/buildroot_platform_hardware_wifi_mtk_drivers_mt7603
cd
git clone https://gitlab.com/ChalesYu/buildroot_platform_hardware_wifi_mtk_drivers_mt7603.git mt7603u
cd mt7603u
git checkout pub-test-v20220304

sudo cp conf/MT7603USTA.dat /lib/firmware/MT7603USTA.dat

echo "\n"

echo "Enter the architecture of this system (arm64/x86_64): "
read ARCHITECTURE

echo "Architecture is $ARCHITECTURE"
echo "Continue (y/n): "

read answer

if [ answer == 'y' ] || [ answer == 'Y' ]
then
    continue
else
    exit 0
fi

### Change Makefile options
sed -i "s/ARCH ?= x86_64/ARCH ?= $ARCHITECTURE/g" Makefile

# Build
make KSRC=/lib/modules/$(uname -r)/build -j$(nproc --all)
sudo cp os/linux/mt7603usta.ko /lib/modules/$(uname -r)/kernel/drivers/net/wireless/
sudo depmod -a
sudo modprobe mt7603usta

### Keep wlanX persistent after reboots
echo 
ip a
echo

echo "Enter MAC adress: "
read MAC_ADRESS
echo
echo "Enter wlan adapter: "
read WLAN_ADAPTER

echo "MAC adress is $MAC_ADRESS"
echo "Adapter name is $WLAN_ADAPTER"
echo "Continue (y/n): "

read answer

if [ answer == 'y' ] || [ answer == 'Y' ]
then
    continue
else
    exit 0
fi

# https://forums.raspberrypi.com/viewtopic.php?t=198687
sudo echo 'SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="'$MAC_ADRESS'", NAME="'$WLAN_ADAPTER'"' > /etc/udev/rules.d/72-xxx.rules
