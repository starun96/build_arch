#!/bin/bash

### ISO root commands ###

    # supposed to run the following before script
        # git clone https://github.com/starun96/build_arch
        # cd build_arch
        # ./root_uefi.sh

    # select wifi network
        wifi-menu

    # update system clock
        timedatectl set-ntp true

    # create partitions (assuming /dev/sda is the disk that is to be partitioned)
        fdisk /dev/sda

    # format partitions
        mkfs.fat -F32 /dev/sda1 # boot
        mkfs.ext4 /dev/sda2 # root
        mkfs.ext4 /dev/sda4 # home

    # configure swap partition
        mkswap /dev/sda3
        swapon /dev/sda3
    
    # mount partitions
        mount /dev/sda2 /mnt # root
        mkdir -p /mnt/{home,boot} # create mount points
        mount /dev/sda4 /mnt/home # home
        mount /dev/sda1 /mnt/boot # boot (EFI)

    # install base packages
        pacstrap /mnt base base-devel

    # create fstab file
        genfstab -U /mnt >> /mnt/etc/fstab

    # root into disk
        arch-chroot /mnt bash /home/$personaldir/scripts/build_arch_disk.sh

    # unmount
        cd
        umount /mnt/$personaldir
        umount /mnt/home
        umount /mnt/boot
        umount /mnt
        
    # reboot
        reboot