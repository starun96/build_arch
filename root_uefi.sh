#!/bin/bash

### ISO root commands ###

    # supposed to run the following before script
        # git clone https://github.com/starun96/build_arch
        # bash build_arch/root_uefi.sh sda sdb3

    # select wifi network
        wifi-menu

    # update system clock
        timedatectl set-ntp true

    # set up target disk and personal partition
        disk=$1
        if [[ -z $disk ]]; then
            echo "Must enter a proper disk ID (such as sda)"
            exit
        fi
        personalpartition=$2
        if [[ -z $personalpartition ]]; then
            echo "Must enter a proper partition ID (such as sdb3)"
            exit
        fi

    # create partitions
        fdisk /dev/$disk

    # format partitions
        mkfs.fat -F32 /dev/${disk}1 # boot
        mkfs.ext4 /dev/${disk}2 # root
        mkfs.ext4 /dev/${disk}4 # home

    # configure swap partition
        mkswap /dev/${disk}3
        swapon /dev/${disk}3
    
    # mount partitions
        mount /dev/${disk}2 /mnt # root
        mkdir /mnt/{home,boot} # create mount points
        mount /dev/${disk}4 /mnt/home # home
        mount /dev/${disk}1 /mnt/boot # boot (EFI)

    # install base packages to root directory
        pacstrap /mnt base base-devel

    # create fstab file
        genfstab -U /mnt >> /mnt/etc/fstab

    # copy chroot script into the disk
        cp build_arch/chroot.sh /mnt

    # root into disk and begin next phase of the installation process
        arch-chroot /mnt bash chroot.sh $personalpartition

    # unmount everything
        umount -R /mnt
        
    # reboot (not until script is finalized, though)
        #reboot