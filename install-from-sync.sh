#!/bin/sh
mkdir -p ~/.local/share/fcitx5
mkdir -p ~/.config/neomutt
cp -r ~/CloudBox/Sync/RimeSync/Rime ~/.local/share/fcitx5/rime
cp -r ~/CloudBox/Private/Backups/Fonts ~/.local/share/fonts
cp -r ~/CloudBox/Private/Mail/accounts ~/.config/neomutt/accounts
fc-cache
