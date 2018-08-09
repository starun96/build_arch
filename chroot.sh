#!/bin/bash

### Initialization ###

    # vars
        user=tarun
        target_drive=$1
        device=$2

    # change language settings
        sed -Ei 's/#en_US/en_US/g' /etc/locale.gen
        locale-gen
        echo 'LANG=en_US.UTF-8' > /etc/locale.conf

    # provide hostname
        read -p 'Enter the host name: ' host_name
        echo $host_name > /etc/hostname

    # change time zone info
        ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

    # do time stuff
        hwclock --systohc --utc

    # add root password
        passwd

    # create new user
        useradd -m -g wheel "$user"
        passwd "$user"

    # change user permissions 
        sed -Ei 's/# %wheel ALL=\(ALL\) ALL$/' /etc/sudoers

    # download user script
        curl https://raw.githubusercontent.com/starun96/build_arch/master/user.sh > /home/$user/user.sh
        chmod +x /home/$user/user.sh

    # switch into user to install packages
        su -c "bash /home/$user/user.sh" - $user

    # grub
        if [ $device = 'desktop' ]; then
            grub-install --target=i386-pc /dev/$target_drive
        else
            grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id="Arch Linux"
        fi
        
        grub-mkconfig -o /boot/grub/grub.cfg

    # exit to iso root for finalization
        exit