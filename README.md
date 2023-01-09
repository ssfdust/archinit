## Archlinux安装笔记

### 初始化

1. 安装脚本

    ```
    # 此时安装git必须为第一步
    编辑/etc/pacman.d/mirrorlist
    pacman -Sy git
    hostnamectl set-hostname XXXX
    git clone https://github.91chi.fun/https://github.com/ssfdust/archinit
    cp archinit/mirrorlist /etc/pacman.d/mirrorlist
    # 按照需要编辑archinit/clone-archios-zfs.sh
    sh archinit/clone-archiso-zfs.sh
    sh archiso-zfs/init
    sh archinit/init-disk sda
    sgdisk -n 4:0:+384G -c 4:"ZFS Vol" -t 4:bf00 /dev/sda
    mkfs.vfat /dev/sda3

    # sda4为zfs磁盘地址，16G为swap大小
    sh archinit/init-zfs.sh sda4 16G

    # sda3为boot分区磁盘
    sh archinit/init-pacstrap.sh sda3

    vim /mnt/etc/fstab
    ...zd0就是zfs的swap分区
    cp -a ~/archinit /mnt/root
    arch-chroot /mnt
    ```
2. 编辑locale

    ```
    nvim /etc/locale.gen
    ```
3. 设置时间以及hostname

    ```
    timedatectl set-ntp true
    hwclock --systohc --utc
    ```
4. 配置用户

    ```
    passwd # 设置root密码
    useradd -g users -G storage,wheel,power,network,audio,video -m ssfdust
    passwd ssfdust
    cp -r archinit /home/ssfdust
    chown ssfdust:users /home/ssfdust/archinit
    pacman -Syu
    EDITOR=nvim visudo
    cp -a archinit
    su - ssfdust

    git clone https://github.91chi.fun/https://github.com/ssfdust/dotfiles.git
    nohup syncthing serve --no-browser &
    syncthing generate
    syncthing cli config devices add --device-id $(cat uuid)
    ...去syncthing网盘接受并共享目录
    ...仅共享Sync
    nu dotfiles/bin/autoaccept.nu
    nohup clash -d ~/CloudBox/Sync/apps/clash > /tmp/clash.log &
    ...共享Private
    nu dotfiles/bin/autoaccept.nu
    sh archinit/install-pkgs.sh
    sh archinit/install-wayfire.sh
    # 自Private文件夹同步数据
    sh archinit/install-from-sync.sh
    ```
5. 配置mkinitcpio

    ```
    # nvim /etc/mkinitcpio.conf
    HOOKS=(base udev systemd sd-plymouth autodetect modconf kms keyboard keymap consolefont block sd-zfs filesystems fsck)
    # mkinitcpio -p linux-lts
    ```
6. 卸载zfs挂载，重启

    ```bash
    umount /mnt/boot
    zfs umount -a
    # 若存在无法卸载
    # umount -lf /path/to/mount
    zfs export zroot
    reboot
    ```

### 开机后

#### gpg初始化

```
gpg --import ~/CloudBox/Sync/keys/public-key.asc
gpg --import ~/CloudBox/Sync/keys/private-key.asc
> trust
> save
make gnupg
git config --global commit.gpgSign true
git config --global user.signingkey $(gpg --list-secret-keys --keyid-format=long ssfdust | awk '/sec/{print $2}' | awk -F/ '{ print $2 }')
```

#### Firefox初始化

启动firefox

```bash
cd dotfiles
make firefox
```

#### 图标初始化

```
cd dotfiles
make icons
```
