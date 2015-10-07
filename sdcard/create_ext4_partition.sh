#!/bin/bash

if [ ! -b /dev/mmcblk0 ]; then
	echo "eMMC device is not found!"
	exit 1
fi

fdisk /dev/mmcblk0 < ./new_ext4.fdisk

echo "== Create two ext4 partition Done! =="

exit 0
