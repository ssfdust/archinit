#!/bin/sh
zpool create -f -o ashift=12         \
             -O acltype=posixacl       \
             -O relatime=on            \
             -O xattr=sa               \
             -O dnodesize=legacy       \
             -O normalization=formD    \
             -O mountpoint=none        \
             -O canmount=off           \
             -O devices=off            \
             -O compression=zstd        \
             -R /mnt/zroot             \
             zroot $1
zfs create -o mountpoint=none zroot/ROOT
zfs create -o mountpoint=none zroot/DATA
zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/default
zfs create -o mountpoint=/var -o canmount=off zroot/DATA/var
zfs create -o mountpoint=/var/lib -o canmount=off zroot/DATA/var/lib
zfs create -o mountpoint=/var/lib/containers zroot/DATA/var/lib/containers
zfs create -o mountpoint=/var/log -o canmount=off zroot/DATA/var/log
zfs create -o mountpoint=/var/log/journal -o acltype=posixacl zroot/DATA/var/log/journal
zfs create -o mountpoint=/home zroot/DATA/home
zfs create -o mountpoint=/root zroot/DATA/home/root
zfs create -V 16G -b $(getconf PAGESIZE) -o compression=zle \
      -o logbias=throughput -o sync=always \
      -o primarycache=metadata -o secondarycache=none \
      -o com.sun:auto-snapshot=false zroot/swap
mkswap /dev/zvol/zroot/swap

zpool export zroot
zpool import -d /dev/disk/by-id -R /mnt zroot -N

zfs mount zroot/ROOT/default
zfs mount -a
swapon /dev/zvol/zroot/swap
