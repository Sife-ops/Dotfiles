#!/bin/sh

timedatectl set-ntp true

# after partitioning
pacstrap /mnt \
    base \
    base-devel \
    linux \
    linux-firmware \
    vim \

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# after chroot
ln -sf /usr/share/zoneinfo/US/Pacific/etc/localtime

hwclock --systohc

echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen

locale-gen

echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'coolname' > /etc/hostname
echo '127.0.0.1	localhost
::1		localhost
127.0.1.1	coolname.geofront	coolname' > /etc/hosts

passwd

pacman -S \
    git \
    efibootmgr \
    grub \
    networkmanager \
    man \
    tmux \
    openssh \
    xorg-server \
    xorg-xinit \
    xfce4 \
    xfce4-goodies \
    lightdm \
    lightdm-gtk-greeter

systemctl enable NetworkManager
systemctl enable sshd

echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

### UEFI only
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=arch
### BIOS only
grub-install --target=i386-pc /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg

# add user
useradd -m -g wheel name
passwd name

# dotfiles
git clone --recurse-submodules --branch sife https://github.com/Sife-ops/dotfiles.git
git remote set-url origin git@github.com:Sife-ops/dotfiles.git
