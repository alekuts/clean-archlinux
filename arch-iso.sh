#!/bin/bash


# Get variables from variables
source variables


# Setup disk
if [ $installType == 1 ]; then
  printf "g\nn\n\n\n$bootPart\nt\n1\nn\n\n\n$rootPart\nn\n\n\n$homePart\nw\nq" | fdisk -W always /dev/$disk
elif [ $installType == 2 ]; then
  printf "n\n\n\n$rootPart\nn\n\n\n$homePart\nw\nq" | fdisk -W always /dev/$disk
fi
part="p"
partitionCount=$(lsblk -l /dev/$disk | grep -c "part")
if [ $installType == 1 ]; then
  num=1
  if mkfs.fat -F32 /dev/$disk$part$num; then :
  else
    part=""
    mkfs.fat -F32 /dev/$disk$part$num
  fi
  mkdir -p /mnt/boot/EFI 
  mount /dev/$disk$part$num /mnt/boot/EFI
  num=2
  mkfs.ext4 /dev/$disk$part$num
  mount /dev/$disk$part$num /mnt
  num=3
  mkfs.ext4 /dev/$disk$part$num
  mkdir /mnt/home
  mount /dev/$disk$part$num /mnt/home
elif [ $installType == 2 ]; then
  num=$((partitionCount-1))
  if mkfs.ext4 /dev/$disk$part$num; then :
  else
    part=""
    mkfs.ext4 /dev/$disk$part$num
  fi
  mount /dev/$disk$part$num /mnt
  mkfs.ext4 /dev/$disk$part$partitionCount
  mkdir /mnt/home
  mount /dev/$disk$part$partitionCount /mnt/home
fi


# Install system
while ! pacstrap -K /mnt base linux linux-firmware ; do : ; done
genfstab /mnt -U >> /mnt/etc/fstab


# Move to arch-chroot.sh
cd
mv clean-archlinux/variables /mnt
mv clean-archlinux/arch-chroot.sh /mnt
arch-chroot /mnt bash arch-chroot.sh


# Unmount and reboot
umount /mnt -l
poweroff
