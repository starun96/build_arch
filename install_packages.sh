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