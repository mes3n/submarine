#!/bin/sh

mkdir flash-util

lsblk

echo "\n"

echo "Enter name of disk to flash to: "
read DISK

echo "Disk name is $DISK"
echo "Continue (y/n): "

read answer

if [ "$answer" = "y" -o "$answer" = "Y" ]
then
    echo "starting..."
else
    exit 0
fi

URL=https://downloads.raspberrypi.org/raspios_oldstable_lite_armhf/images/raspios_oldstable_lite_armhf-2022-04-07/2022-04-04-raspios-buster-armhf-lite.img.xz

mkdir flash-util/downloads
wget -O flash-util/downloads/os.img.xz $URL

echo "\n"

# xzcat downloads/os.img.xz | sudo dd bs=4M of=$DISK

sudo mkdir flash-util/mnt
sudo mount /dev/sdc1 flash-util/mnt
cd flash-util/mnt
sudo touch ssh  # enable ssh
echo "pi:$(openssl passwd -6 'raspberry')" | sudo tee userconf.txt  # add user pi with passwd raspberry (default)
cd ../..

sudo umount /dev/sdc*

echo "done"
