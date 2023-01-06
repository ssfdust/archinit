#!/bin/sh
sgdisk -og /dev/$1
sgdisk -n 1:2048:+1M -c 1:"BIOS Boot Partition" -t 1:ef02 /dev/$1
sgdisk -n 2:0:+4M -c 2:"PowerPC Boot Partition" -t 2:4100 /dev/$1
sgdisk -n 3:0:+2G -c 3:"EFI Boot Partition" -t 3:ef00 /dev/$1
# sgdisk -n 4:0:+384G -c 4:"ZFS Vol" -t 4:bf00 /dev/$1
sgdisk -p /dev/$1
# mkfs.vfat /dev/$13
