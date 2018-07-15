#!/bin/bash

### Initialization ###

    # args
        # $1 - personal partition (e.g. sdb3), has personal directory

    # vars
        user=tarun
        personaldir=personal
        personalpartition=$1

    # change language settings
        sed -Ei 's/#en_US/en_US/g' /etc/locale.gen
        locale-gen
        echo 'LANG=en_US.UTF-8' > /etc/locale.conf

    # change time zone info
        rm /etc/localtime
        ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

    # do time stuff
        hwclock --systohc --utc

    # add root password
        passwd

    # create new user
        useradd -m -g wheel "$user"
        passwd "$user"

    # change user permissions 
        sed -Ei 's/# %wheel ALL=\(ALL\) ALL$/ %wheel ALL=\(ALL\) ALL/' /etc/sudoers

    # add personal files to home directory
        mkdir /mnt/$personaldir
        mount /dev/$personalpartition /mnt/$personaldir
        cp /mnt/$personaldir/* /home/$user
        umount /dev/$personalpartition

    # switch into user to install packages
        su - $user

    # grub
        grub-install --target=x86_64-efi -efi-directory=/boot --bootloader-id="Arch Linux"
        grub-mkconfig -o /boot/grub/grub.cfg

    # exit to iso root for finalization
        exit