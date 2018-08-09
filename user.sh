#!/bin/bash

### Setup Various Files ###

    # vars
        email=tarunsaharya@gmail.com
        githubid=starun96
    
### Install programs ###

    # git 
        sudo pacman -S --noconfirm git
        git config --global user.email "$email" 
        git config --global user.name "$githubid" 
        git config --global credential.helper "cache --timeout=3600"

    # yay
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm 
        cd

    # all packages
        curl https://raw.githubusercontent.com/starun96/build_arch/master/packages.txt > packages.txt
        sudo pacman -S --noconfirm jq
        for package in $(jq -c '(.official + .aur)[]' packages.json); do
            yay -S --noconfirm --nodiffmenu "$package"
        done
        for package in $(jq -c '.pip[]' packages.json); do
            pip3 install --user $user "$package"
        done
        for package in $(jq -c '.npm[]' packages.json); do
            npm install "$package"
        done

### Initialize wifi ###

    # enable and start Network Manager
        sudo systemctl enable NetworkManager
        
### Initialize TLP ###

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

### Sync personal files ###
    
    # start syncthing
        syncthing
    
    # configure syncthingmanager
        .local/bin/stman configure

     # add folders
        curl https://raw.githubusercontent.com/starun96/build_arch/master/personal_dirs.txt > personal_dirs.txt
        while read -r dir; do
            stman folder add 
        done < personal_dirs.txt

### Finalize ###

    # change all files in home to be writable and executable
        sudo chmod -R 777 ~

    # exit to chroot mode
        exit