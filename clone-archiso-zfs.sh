#!/bin/sh
rm -rf ~/init

curl -o ~/init -L https://github.91chi.fun/https://github.com/eoli3n/archiso-zfs/blob/master/init

sed -i 's/\[archzfs\]/[archzfs-testing]/' ~/init
sed -i 's/http:\/\/archzfs.com\/archzfs/https:\/\/archzfs.com\/archzfs-testing/g' ~/init
# sed -i 's/http:\/\/archzfs.com/https:\/\/mirror.biocrafting.net\/archlinux\/archzfs/g' ~/init
# sed -i 's/http:\/\/archzfs.com/https:\/\/mirror.in.themindsmaze.com\/archzfs/g' ~/init
# sed -i 's/http:\/\/archzfs.com/https:\/\/zxcvfdsa.com\/archzfs/g' ~/init
