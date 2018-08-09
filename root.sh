#!/bin/bash

### ISO root commands ###

    # MUST EXECUTE FILES BEFORE RUNNING THE SCRIPT
        # wifi-menu (connect to wifi)
        # curl https://raw.githubusercontent.com/starun96/build_arch/master/root.sh > root.sh; done
        # bash root.sh
        # chmod +x root.sh

    # prompt for essential input
        # prompt for target disk
            disk_pattern='^[a-z]$'
            until [[ $target_drive =~ $disk_pattern ]]; do
                read -p 'Please specify the target installation disk letter (e.g. a or b): ' target_drive
            done
            target_drive=sd$target_drive

        # prompt for desktop vs laptop
            device_pattern='^d|l$'
            until [[ $device =~ $device_pattern ]]; do
                read -p 'Please specify whether this machine is the desktop or the laptop. Enter d for Desktop and l for laptop: ' $device
            done
            case "$device" in
                b) device='desktop' ;;
                u) device='laptop' ;;
                *) exit ;;
            esac
            
    # download chroot.sh
        echo "Downloading chroot.sh from Github"
        curl https://raw.githubusercontent.com/starun96/build_arch/master/chroot.sh > chroot.sh
        if [ ! -e chroot.sh ]; then
            echo "Cannot retrieve chroot.sh. Exiting now."
            exit
        fi
        chmod +x chroot.sh
    
    # update system clock
        echo "Updating system clock"
        timedatectl set-ntp true

    # create partitions
        echo "Creating partitions"
        if [ $device = 'desktop' ]; then
            sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << END_DESKTOP | fdisk $target_drive
            o # clear the in memory partition table
            n # create swap
            p # primary
            1 # num 1
                # default - start at beginning of disk 
            +1G # 1 GB swap
            n # create root
            p # primary 
            2 # num 2
                # default, start immediately after preceding partition
                # default, extend partition to end of disk
            a # choose bootable partition
            2 # make root partition bootable
            p # print the in-memory partition table
            w # write the partition table to disk
END_DESKTOP

        else
            sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << END_LAPTOP | fdisk $target_drive
            g # clear the in memory partition table
            n # create boot
            p # primary
            1 # num 1
                # default - start at beginning of disk 
            +512M # 512M boot
            n # create swap
            2 # num 2
                # default, start immediately after preceding partition
            +1G # 1GB swap
            n # create root
            p # primary
            3 # num 3
                # default, start immediately after preceding partition
                # default, take until end of disk
            p # print the in-memory partition table
            w # write the partition table
END_LAPTOP

    # format partitions
        echo "Formatting Partitions"
        if [ $device = 'desktop' ]; then
            mkswap /dev/${target_drive}1 # create swap
            swapon /dev/${target_drive}1 # activate swap
            mkfs.ext4 /dev/${target_drive}2 # root
        else
            mkfs.fat -F32 /dev/${target_drive}1 # boot
            mkswap /dev/${target_drive}2 # create swap
            swapon /dev/${target_drive}2 # activate swap
            mkfs.ext4 /dev/${target_drive}3 # root
        fi
    
    # mount partitions
        echo "Mounting Partitions"
        if [ $device = 'desktop' ]; then
            mount /dev/${target_drive}2 /mnt # root
        else
            mount /dev/${target_drive}3 /mnt # root
            mkdir /mnt/boot # boot    
            mount /dev/${target_drive}1 /mnt/boot # boot (EFI)
        fi            

    # install base packages to root directory
        echo "Installation Base Packages"
        pacstrap /mnt base base-devel

    # create fstab file
        echo "Creating Fstab file"
        genfstab -U /mnt >> /mnt/etc/fstab

    # copy extra scripts onto the disk
        echo "Copying further installation scripts onto the disk"
        
    # root into disk and begin next phase of the installation process
        mv chroot.sh /mnt
        arch-chroot /mnt bash chroot.sh $target_drive $device

    # unmount everything
        umount -R /mnt