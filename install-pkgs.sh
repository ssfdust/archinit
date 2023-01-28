#!/bin/sh
cd ~/dotfiles
proxychains -q make pacman
sudo pacman -Sy --noconfirm archlinuxcn-keyring
sudo pacman -S --noconfirm powerpill bauerbill
make pacman
bb-wrapper -S --noconfirm $(grep -v AUR misc/packages.txt)
sudo refind-install
proxychains -q bauerbill -S --aur --build-dir ~/build $(grep AUR misc/packages.txt)
echo please install files in ~/build
