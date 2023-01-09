#!/bin/sh
rm -rf ~/archiso-zfs

git clone https://github.91chi.fun/https://github.com/eoli3n/archiso-zfs ~/archiso-zfs

sed -i "s/http:\/\/archzfs.com/https:\/\/mirror.biocrafting.net\/archlinux\/archzfs/g" ~/archiso-zfs/init
# sed -i "s/http:\/\/archzfs.com/https:\/\/mirror.in.themindsmaze.com\/archzfs/g" ~/archiso-zfs/init
# sed -i "s/http:\/\/archzfs.com/https:\/\/zxcvfdsa.com\/archzfs/g" ~/archiso-zfs/init
