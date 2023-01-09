mkdir /mnt/boot
mount /dev/$1 /mnt/boot
pacstrap /mnt base \
    base-devel \
    linux-lts \
    zfs-linux-lts \
    linux-firmware \
    refind \
    neovim \
    aria2 \
    starship \
    git \
    nushell \
    networkmanager \
    syncthing \
    jq \
    nftables \
    proxychains \
    clash \
    ansible

cp archinit/mirrorlist /mnt/etc/pacman.d/mirrorlist
echo LANG=en_US.UTF-8 > /mnt/etc/locale
hostnamectl hostname > /mnt/etc/hostname

cat > /etc/proxychains.conf <<EOF
strict_chain
proxy_dns 
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
http 	127.0.0.1 7890
EOF

genfstab -U -p /mnt | grep -v "^zroot" >> /mnt/etc/fstab
cp /etc/zfs/zpool.cache /mnt/etc/zfs
cp -a /etc/zfs/zfs-list.cache /mnt/zfs

