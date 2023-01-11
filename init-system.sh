#!/bin/sh
rm -f /etc/zfs/zpool.cache
zpool set cachefile=/etc/zfs/zpool.cache zroot
# Fix the paths to eliminate /mnt
sed -Ei "s|/mnt/?|/|" /etc/zfs/zfs-list.cache/*
zgenhostid $(hostid)

locale-gen
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
plymouth-set-default-theme -R arch-charge-big

cp /home/ssfdust/CloudBox/Sync/apps/clash/* /etc/clash/
chown -R nobody:nobody /etc/clash

systemctl enable zfs.target zfs-import-cache zfs-import.target zfs-zed \
    NetworkManager sddm-plymouth firewalld libvirtd plocate-updatedb.timer \
    nfs-server syncthing@ssfdust clash@nobody
systemctl disable systemd-resolved
