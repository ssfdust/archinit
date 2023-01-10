#!/bin/sh
set -e
pooldisk=$(ls -l /dev/disk/by-partuuid | awk "/$1/ { print \$9 }" | xargs echo)
zpool create -f -o ashift=12         \
             -O acltype=posixacl       \
             -O atime=off              \
             -O relatime=on            \
             -O xattr=sa               \
             -O dnodesize=legacy       \
             -O normalization=formD    \
             -O mountpoint=none        \
             -O canmount=off           \
             -O devices=off            \
             -O compression=zstd       \
             -R /mnt/zroot             \
             zroot $1

zpool set cachefile=/etc/zfs/zpool.cache zroot

# enable zfs-mount-generator
systemctl start zfs-zed

mkdir /etc/zfs/zfs-list.cache
touch /etc/zfs/zfs-list.cache/zroot

zfs create -o mountpoint=none                 zroot/ROOT
zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/default

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

zfs create                                    zroot/opt

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

zfs umount -a
zpool export zroot

rm -rf /mnt/*

zpool import -d /dev/disk/by-partuuid -R /mnt zroot -N \
    || zpool import -R /mnt zroot -N

zfs mount zroot/ROOT/default
zfs mount -a

swapon /dev/zvol/zroot/swap
