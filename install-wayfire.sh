#!/bin/sh
git clone https://github.91chi.fun/https://github.com/ssfdust/wayfire-pkgbuild /dev/shm/wayfire-installer
cd /dev/shm/wayfire-installer
nvim updatepkgs.sh
proxychains -q sh updatepkg.sh
