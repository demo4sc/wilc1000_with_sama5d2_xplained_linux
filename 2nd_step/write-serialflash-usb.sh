#!/bin/sh
# Flash a Linux-based demo 

echo "===== Flashing demo to board ====="
../samba-3.0-pre3/sambacmd -x write-serialflash-usb.qml
../samba-3.0-pre3/sambacmd -x write-boot_sequence-usb.qml
echo "===== Script done. ====="
exit 0
