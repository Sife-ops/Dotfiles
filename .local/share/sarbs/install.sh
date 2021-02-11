#!/bin/sh

# after partitioning
pacstrap /mnt \
    base \
    base-devel \
    linux \
    linux-firmware \
    vim \
    git \
    efibootmgr \
    grub \
    networkmanager \
    openssh

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# after chroot
ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'nothingburger' > /etc/hostname
echo '127.0.0.1	localhost
::1		localhost
127.0.1.1	nothingburger.geofront	nothingburger' > /etc/hosts
passwd
systemctl enable NetworkManager
systemctl enable sshd
echo 'PermitRootLogin yes' > /etc/ssh/sshd_config

### UEFI only
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=sarbs
### BIOS only
grub-install --target=i386-pc /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg
