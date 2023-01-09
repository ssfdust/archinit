#!/bin/sh
cd ~/dotfiles
proxychains -q make pacman
sudo pacman -S archlinuxcn-keyring
sudo pacman -S powerpill bauerbill
make pacman
bb-wrapper -S $(grep -v AUR misc/packages.txt)
proxychains -q bb-wrapper -S --aur-only --build-dir ~/build $(grep AUR misc/packages.txt)
mkdir -p ~/.local/share/mail/{gmail,qq,juminfo}
notmuch setup
make headless
