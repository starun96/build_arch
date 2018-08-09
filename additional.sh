#!/bin/bash

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

    # enable tlp for laptop and mask services to avoid conflicts
        if [ $device = 'laptop' ]; then
            yay -S --noconfirm --nodiffmenu tlp tlpui-git
            sudo systemctl enable tlp
            sudo systemctl enable tlp-sleep
            sudo systemctl mask systemd-rfkill.service
            sudo systemctl mask systemd-rfkill.socket
        fi

    # enable NVIDIA graphics for desktop
        if [ $device = 'desktop' ]; then
            yay -S --noconfirm --nodiffmenu nvidia
        fi