# Clean Arch Linux Install Script

## About
This script is designed for an easy and clean installation of Arch Linux, or for a clean Arch Linux installation alongside another operating system.

## What is required for installation?

1. Your motherboard must support UEFI.
2. The drive must support GPT partition table.

## How to start the installation?

1. Download the .iso file from the [Arch Linux Downloads](https://archlinux.org/download/) page.
2. Write the .iso to a USB flash drive using [Rufus](https://rufus.ie/).
3. Insert the flash drive into your computer, go into the motherboard's BIOS/UEFI settings, and set your USB flash drive as the boot device.
4. Make sure your computer is connected to a wired Ethernet internet connection.
5. Install git by running the command: ```pacman -Sy git```
6. Clone the repository with: git clone ```https://github.com/alekuts/clean-archlinux.git```
7. Navigate to the script directory: ```cd clean-archlinux```
8. To start the installation process, run: ```bash pre-install.sh```

## What to do if you make a mistake?

If you make a mistake at any step before installation starts, press ```Ctrl + C``` to stop the script.

Good luck🔥
