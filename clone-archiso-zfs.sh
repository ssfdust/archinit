#!/bin/sh

git clone https://github.91chi.fun/https://github.com/eoli3n/archiso-zfs ~/archiso-zfs

sed -i "s/archzfs.com/mirror.biocrafting.net\/archlinux\/archzfs/g" ~/archiso-zfs/init
# sed -i "s/archzfs.com/mirror.in.themindsmaze.com\/archzfs/g" ~/archiso-zfs/init
# sed -i "s/archzfs.com/zxcvfdsa.com\/archzfs/g" ~/archiso-zfs/init
