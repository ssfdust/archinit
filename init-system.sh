#!/bin/sh
locale-gen
systemctl enable libvirtd clash@nobody zfs.target zfs-import-cache zfs-zed NetworkManager sddm-plymouth syncthing@ssfdust
systemctl disable gnome-keyring-daemon.service gnome-keyring-daemon.socket --user
systemctl disable systemd-resolved

plymouth-set-default-theme -R arch-charge-big
ln -s /usr/share/zoneinfo/Shanghai /etc/localtime
zpool set cachefile=/etc/zfs/zpool.cache zroot
zgenhostid $(hostid)
