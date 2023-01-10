## Archlinux Installation Guide

**Recommend to run in tmux mode**

```
set-window-option -g  mode-keys vi
```

### Preparation

1. Select archlinux source mirror，edit /etc/pacman.d/mirrorlist
2. Check dns server, set it to 114.114.114.114
3. set host name

    hostnamectl set-hostname XXXX
4. download helper script

    ```bash
    pacman -Sy git
    git clone https://github.91chi.fun/https://github.com/ssfdust/archinit
    ```

### Disk

#### Clone archiso-zfs

edit archinit/clone-archios-zfs.sh as desired

```bash
sh archinit/clone-archiso-zfs.sh
```

#### Add zfs support

```bash
sh init
```

#### Create partitions and filesystems

```bash
sh archinit/init-disk.sh sda
sgdisk -n 4:0:+384G -c 4:"ZFS Vol" -t 4:bf00 /dev/sda
mkfs.vfat /dev/sda3
# the first argument is the zfs partition, the latter is swap memory size
sh archinit/init-zfs.sh sda4 16G
```

* Check mounts, if there're some errors. Try umount -lf /path/mount, zfs mount -a

### Bootstrap installation

```bash
# sda3 is the boot partition
sh archinit/init-pacstrap.sh sda3
...Check whether /mnt/etc/hostname is valid.
vim /mnt/etc/fstab
...zd0 is the zfs swap, it should be uuid format
cp -a ~/archinit /mnt/root
vim /mnt/etc/local.gen
```

### Chroot

#### Add user and configure sudoers

```bash
arch-chroot /mnt
passwd
useradd -g users -G storage,wheel,power,network,audio,video -m ssfdust
passwd ssfdust
cp -r archinit /home/ssfdust
chown ssfdust:users /home/ssfdust/archinit
pacman -Syu
EDITOR=nvim visudo
```

### After switch to common user

#### Syncthing and clash

```bash
su - ssfdust
git clone https://github.91chi.fun/https://github.com/ssfdust/dotfiles.git

# config syncthing
syncthing generate
nohup syncthing serve --no-browser > /tmp/syncthing.log &
...Check syncthing log, wait for syncthing to start

syncthing cli config devices add --device-id $(cat uuid)
...Accept the request device and only share the Sync directory on remote
...Check log in local, wait for accept request
nu dotfiles/bin/autoaccept.nu

...Check ~/CloudBox/Sync/apps/clash is ready
...only share the Private directory on remote
nu dotfiles/bin/autoaccept.nu

# config clash
nohup clash -d ~/CloudBox/Sync/apps/clash > /tmp/clash.log &
```

#### Install system packages

```bash
sh archinit/install-pkgs.sh

cd ~/build
proxychains -q sh download.sh
proxychains -q sh build.sh

cd ~
sh archinit/install-wayfire.sh
sh archinit/install-from-sync.sh
sh archinit/user-disable.sh

cd ~/dotfiles
cp ~/CloudBox/Sync/keys/secrets.yml ~/dotfiles
proxychains -q make headless
```

### Back to chroot

```
# nvim /etc/mkinitcpio.conf
HOOKS=(base udev systemd sd-plymouth autodetect modconf kms keyboard keymap consolefont block sd-zfs filesystems fsck)
# mkinitcpio -p linux-lts
# sh archinit/init-system.sh
```

### umount zfs and reboot

```bash
umount /mnt/boot
zfs umount -a
# umount -lf /path/to/mount
swapoff /dev/zvol/zroot/swap
zfs export zroot

reboot
```
