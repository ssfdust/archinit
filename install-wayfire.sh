#!/bin/sh
git clone https://github.91chi.fun/https://github.com/ssfdust/wayfire-build /dev/shm/wayfire-installer
cd /dev/shm/wayfire-installer
vim updatepkgs.sh
proxychains -q sh updatepkg.sh
