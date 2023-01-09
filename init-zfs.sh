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

zpool set cachefile=/etc/zfs/zpool.cache zroot
touch /etc/zfs/zfs-list.cache/zroot

zfs create -o mountpoint=none                 zroot/ROOT
zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/default

# enable zfs-mount-generator
mkdir /etc/zfs/zfs-list.cache
systemctl start zfs-zed

zfs create -o mountpoint=none                 zroot/data
zfs create -o mountpoint=/home                zroot/data/home
zfs create -o mountpoint=/root                zroot/data/home/root

zfs create -o mountpoint=/var -o canmount=off zroot/var
zfs create -o canmount=off                    zroot/var/lib
zfs create -o com.sun:auto-snapshot=false     zroot/var/lib/containers
zfs create -o com.sun:auto-snapshot=false     zroot/var/lib/nfs
zfs create                                    zroot/var/lib/libvirt
zfs create                                    zroot/var/log
zfs create                                    zroot/var/spool
zfs create -o com.sun:auto-snapshot=false     zroot/var/cache
zfs create -o com.sun:auto-snapshot=false     zroot/var/tmp

zfs create -V $2 \
    -b $(getconf PAGESIZE) \
    -o compression=zle \
    -o logbias=throughput \
    -o sync=always \
    -o primarycache=metadata \
    -o secondarycache=none \
    -o com.sun:auto-snapshot=false \
    zroot/swap

mkswap /dev/zvol/zroot/swap

zpool set bootfs=zroot/ROOT/default zroot

zpool export zroot

rm -rf /mnt/*

zpool import -d /dev/disk/by-uuid -R /mnt zroot -N || zpool import -R /mnt zroot

zfs mount zroot/ROOT/default
zfs mount -a

swapon /dev/zvol/zroot/swap
