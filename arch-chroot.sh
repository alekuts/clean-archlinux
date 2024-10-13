#!/bin/bash


# Get variables from variables
source variables


# Install keys, packages and setup multilib
pacman-key --init
pacman-key --populate
sed -Ei 's/#(\[multilib\])/\1/' /etc/pacman.conf
sed -i '/\[multilib\]/ {n;s/#//}' /etc/pacman.conf
while ! pacman -Syu --noconfirm dhcpcd sudo grub efibootmgr os-prober ; do : ; done


# Ethernet
systemctl enable dhcpcd


# Timezone
ln -sf /usr/share/zoneinfo/$region/$capital /etc/localtime
hwclock --systohc


# Setup en locale
sed -Ei 's/#(en_US.*UTF-8)/\1/' /etc/locale.gen
locale-gen


# Hostname, root and user
printf "$hostname" > /etc/hostname
printf "127.0.0.1 localhost
::1 localhost
127.0.1.1 $hostname.localdomain $hostname" > /etc/hosts
printf "$rootPasswd\n$rootPasswd" | passwd
useradd -m $username
printf "$userPasswd\n$userPasswd" | passwd $username
usermod -aG wheel $username
sed -Ei 's/# (%wheel ALL.*ALL\) ALL)/\1/' /etc/sudoers


# Setup GRUB bootloader
if [ $installType -eq 1 ]; then
  pacman -Rns --noconfirm os-prober
fi
printf "GRUB_DISABLE_OS_PROBER=false\n" >> /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot/EFI
grub-mkconfig -o /boot/grub/grub.cfg


# Delete unnecessary files
rm -f arch-chroot.sh variables
