## Archlinux安装笔记

### 初始化

1. 安装脚本

    ```
    # 此时安装git必须为第一步
    编辑/etc/pacman.d/mirrorlist
    pacman -Sy git

    git clone https://github.91chi.fun/https://github.com/ssfdust/archinit
    cp archinit/mirrorlist /etc/pacman.d/mirrorlist
    sh archinit/clone-archiso-zfs.sh
    sh archiso-zfs/init
    sh archinit/init-disk sda
    sgdisk -n 4:0:+384G -c 4:"ZFS Vol" -t 4:bf00 /dev/sda
    mkfs.vfat /dev/sda3

    pooldisk=$(ls /dev/disk/by-partuuid -l | awk '/sda4/{print $9}')
    sh archinit/init-zfs.sh $pooldisk

    sh archinit/init-pacstrap.sh
    mount /dev/sda3 /mnt/boot

    cp /etc/zfs/zpool.cache /mnt/etc/zfs

    genfstab -U -p /mnt | grep -v "^zroot" >> /mnt/etc/fstab

    vim /mnt/etc/fstab
    ...zd0就是zfs的swap分区
    cp archinit/mirrorlist /mnt/etc/pacman.d/mirrorlist

    arch-chroot /mnt
    ```
2. 编辑locale

    ```
    nvim /etc/locale.gen
    取消en_US,zh_CN的注释
    locale-gen
    echo LANG=en_US.UTF-8 > /etc/locale
    refind-install
    zpool set cachefile=/etc/zfs/zpool.cache zroot
    zgenhostid $(hostid)
    ```
3. 设置时间以及hostname

    ```
    ln -s /usr/share/zoneinfo/Shanghai /etc/localtime
    timedatectl set-ntp true
    hwclock --systohc --utc
    hostnamectl set-hostname RedLotus
    ```
4. 配置用户

    ```
    passwd # 设置root密码
    useradd -g users -G storage,wheel,power,network,audio,video -m ssfdust
    passwd ssfdust

    EDITOR=nvim visudo

    su - ssfdust

    git clone https://github.91chi.fun/https://github.com/ssfdust/dotfiles.git
    nohup synchint --no-browser &
    syncthing generate
    syncthing cli config devices add --device-id $(cat uuid)
    ...去syncthing网盘接受并共享目录
    ...仅共享Sync
    nu bin/autoaccept.nu
    nohup clash -d ~/CloudBox/Sync/apps/clash > /tmp/clash.log &
    cd dotfiles
    sudo nvim /etc/proxychains.conf
    proxychains -q make pacman
    pacman -Syu
    pacman -S archlinuxcn-keyring
    pacman -S powerpill bauerbill
    make pacman
    cd ~
    proxychains -q bb-wrapper -S --aur --build-dir ~/.cache/updatepkg $(cat misc/packages.txt)
    echo "HOSTNAME" > /etc/hostname
    systemctl enable libvirtd clash@nobody zfs.target zfs-import-cache zfs-mount zfs-import.target NetworkManager sddm-plymouth
    ```
5. gpg初始化

    ```
    gpg --import ~/CloudBox/Sync/keys/public-key.asc
    gpg --import ~/CloudBox/Sync/keys/private-key.asc
    gpg --edit-key --expert ssfdust
    > trust
    > save
    ```
6. 配置mkinitcpio

    ```
    nvim /etc/mkinitcpio.conf

    HOOKS=(base udev systemd sd-plymouth autodetect modconf kms keyboard keymap consolefont block sd-zfs filesystems fsck)
    mkinitcpio -p linux-lts
    make refind

    ```
7. 重启
    ```
    swapoff /dev/zd0
    zfs umount -a
    zpool export zroot
    ```

### 桌面配置

    ```
    git clone https://github.91chi.fun/https://github.com/ssfdust/wayfire-pkgfile /dev/shm/wayfire-installer
    cd wayfire-installer
    proxychains -q sh updatepkg.sh
    ```

### 配置git
    ```
  	git config --global commit.gpgSign true
    git config --global user.signingkey $(gpg --list-secret-keys --keyid-format=long ssfdust | awk '/sec/{print $2}' | awk -F/ '{ print $2 }')
    ```
