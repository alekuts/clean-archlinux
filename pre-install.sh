#!/bin/bash


install-type() {
  printf "Install type:\n 1) Arch Linux\n 2) Arch Linux dual boot\n"
  read installType
  case $installType in
    1 | 2) clear
      ;;
    *) clear
       printf "\033[41mSelect valid option\033[0m\n\n"
       return 1;
      ;;
  esac
}


disk() {
  fdisk -l
  printf "\nEnter disk\nExamples: sda, nvme0n1\n"
  read disk
  if lsblk | grep -wq /dev/$disk; then
    clear
  else
    clear
    printf "\033[41mInvalid disk name\033[0m\n\n"
    return 1;
      printf "\033[41mInvalid partition name\033[0m\n\n"
  fi
}


partitions() {
  if [ $installType -eq 1 ]; then
    printf "Enter partition size for bootloader\nExamples: +512M, +1G\n"
    read bootPart
  elif [ $installType -eq 2 ]; then
    fdisk -l
    printf "\nEnter EFI or boot partition name of another system\nExamples: sda, nvme0n1p1\n"
    read bootPart
    if lsblk | grep -q /dev/$bootPart; then :
    else
      printf "\033[41mInvalid partition name\033[0m\n\n"
      return 1;
    fi
  fi

  printf "Enter system or root partition size\nExample: +80G\n"
  read rootPart
  printf "Enter home partition size\nPress ENTER for all free space\n"
  read homePart
  clear
}


zoneinfo() {
  ls /usr/share/zoneinfo/
  printf "\nEnter your region\nExample: Europe"
  read region
  if ls /usr/share/zoneinfo/$region; then
    printf "\nEnter your capital\nExample: Europe"
    read capital
    if ls /usr/share/$region/$capital &> /dev/null; then
      clear
    else
      printf "\033[41mInvalid capital name\033[0m\n\n"
      return 1;
    fi
  else
    printf "\033[41mInvalid region name\033[0m\n\n"
    return 1;
  fi
}


host-user-name() {
printf "Enter hostname or pc name and username following these rules:\n1. No root, bin, daemon, etc. names.\n2. Length 2-32 characters.\n3. Allowed characters: Only lowercase letters (a-z), digits (0-9), hyphen (-), and underscore (_).\n4. No starting with digit.\n"
read -p "\nHostname: " hostname
read -p "\nUsername: " username
}


passwords() {
printf "Enter root and username passwords following this rules:\nMinimum length: At least 6 characters.\nVariety of characters: Use a mix of uppercase, lowercase letters, numbers, and special characters.\nYou will not see the password\n"
read -s -p "\nRoot password: " rootPasswd
read -s -p "\nRepeat password: " rootPasswdTest
if [[ $rootPasswd == $rootPasswdTest ]]; then
  read -s -p "\nUser password: " userPasswd
  read -s -p "\nRepeat password: " userPasswdTest
  if [[ $userPasswd == $userPasswdTest ]]; then
    clear
  else
    return 1;
  fi
else
  return 1;
fi
}


clear
if ping -c 1 google.com &> /dev/null; then
  printf "\nInstalling Time Zone Database.."
  while ! pacman -Sy --noconfirm tzdata &> /dev/null; do sleep 5; clear; done
  clear
  printf "Welcome to the Clean Archlinux!\nConfigure the installation with clear questions and wait until your device turns off\nPress ENTER to start\n"
  read -s
  clear
  while ! install-type; do : ; done
  while ! disk; do : ; done
  while ! partitions; do : ; done
  while ! zoneinfo; do : ; done
  host-user-name
  while ! passwords; do : ; done
  cd
  printf "installType=$installType\ndisk=$disk\nbootPart=$bootPart\nrootPart=$rootPart\nhomePart=$homePart\nregion=$region\ncapital=$capital\nhostname=$hostname\nusername=$username\nrootPasswd=$rootPasswd\nuserPasswd=$userPasswd" > clean-archlinux/variables
  bash arch-iso.sh
else
  printf "\033[41mNo internet connection!\033[0m\n"
fi