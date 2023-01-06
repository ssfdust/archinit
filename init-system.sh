#!/bin/sh
systemctl enable libvirtd clash@nobody zfs.target zfs-import-cache zfs-mount zfs-import.target NetworkManager sddm-plymouth
systemctl disable systemd-resolved
