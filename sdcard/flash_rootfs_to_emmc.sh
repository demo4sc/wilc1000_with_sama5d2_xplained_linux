#!/bin/bash

EMMC_PARTITION=/dev/mmcblk0p1
EMMC_PARTITION_USER=/dev/mmcblk0p2
SD_PARTITION=/dev/mmcblk1p1
DEMO_ROOTFS_TAR=rootfs.tar.gz

if [ ! -b /dev/mmcblk0 ]; then
	echo "eMMC device is not found!"
	exit 1
fi

if [ ! -b ${SD_PARTITION} ]; then
	echo "SD card is not found!"
	exit 1
fi

# destroy the partition table
dd if=/dev/zero of=/dev/mmcblk0 bs=10M count=1

echo "Will delete two eMMC partitions! Then create 1G size ext4 partition for rootfs."
./create_ext4_partition.sh
sleep 1

if [ ! -b ${EMMC_PARTITION} ]; then
	echo "Failed to create the ext4 partition for rootfs!"
	exit 1
fi
if [ ! -b ${EMMC_PARTITION_USER} ]; then
	echo "Failed to create the ext4 partition for user data on Android!"
	exit 1
fi

mke2fs -T ext4 ${EMMC_PARTITION}
mke2fs -T ext4 ${EMMC_PARTITION_USER}
echo "== Format eMMC partition as ext4. Done. =="

sleep 1
mount -t ext4 ${EMMC_PARTITION} /mnt
if [ $? != 0 ]; then
	echo "Cannot mount the ext4 partition!"
	exit 1
fi

sleep 1

if [ ! -f /home/root/${DEMO_ROOTFS_TAR} ]; then
	echo "Demo rootfs is not found!"
	exit 1
fi

sleep 1
tar xvf /home/root/${DEMO_ROOTFS_TAR} -C /mnt
if [ $? != 0 ]; then
	echo "Cannot extract the tar ball to eMMC partition! Please check it"
	exit 1
fi

sleep 3
sync

umount /mnt

echo "== Done =="
echo 255 > /sys/class/leds/green/brightness
exit 0
