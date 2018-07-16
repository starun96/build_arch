#!/bin/bash

### Setup Various Files ###

    # should run the following before executing this script
        # bash /user.sh

    # vars
        email=tarunsaharya@gmail.com
        githubid=starun96
        user=tarun
        personaldir=personal

    # profile
        rm .bash_profile
        ln configs/profile.conf .profile

    # bash aliases
        ln configs/bash_aliases .bash_aliases

    # Xresources 
        ln configs/Xresources .Xresources

    # bashrc 
        rm .bashrc
        ln configs/bashrc .bashrc

    # xinitrc 
        ln configs/xinitrc .xinitrc
    
    # vim
        ln configs/vim/vimrc .vimrc

    # i3
        mkdir .config/i3
        ln configs/i3 .config/i3/config

    # special installers folder
        mkdir special_installers



### Setup programs ###

    # git 
        sudo pacman -S --noconfirm git
        git config --global user.email "$email" 
        git config --global user.name "$githubid" 
        git config --global credential.helper "cache --timeout=3600"
    
    # yay
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd /home/$user

    # most packages
        while read -r package; do
            yay -S --noconfirm -nodiffmenu "$package"
        done < configs/aur_packages.txt
    
    # vtop
        sudo npm install -g vtop

    # network manager
        sudo systemctl enable NetworkManager

    # lightdm
        sudo systemctl enable lightdm.service

    # dynpaper 
        cd special_installers
        git clone https://github.com/oddProton/dynpaper
        cd dynpaper
        sudo ./setup.py install
        cd /home/$user

    # vscode
        mkdir -p .config/Code/User
        ln configs/vscode_settings.json .config/Code/User/settings.json
        ln configs/vscode_keybindings.json .config/Code/User/keybindings.json
 
    # autokey
        ln -s configs/autokey .config/autokey
        
    # ranger
        mkdir .config/ranger
        ln configs/ranger/rifle.conf .config/ranger/rifle.conf

    # vscode
        mkdir -p .config/Code/User         
        ln configs/vscode_settings.json .config/Code/User/settings.json
        ln configs/vscode_keybindings.json .config/Code/User/keybindings.json
        ln -s configs/vscode_extensions .vscode/extensions



### Miscellaneous ###

    # fonts
        cp -r aesthetic/fonts/* .local/share/fonts
        fc-cache -f -v

    # icons
        cp -r aesthetic/icons/* .local/share/icons



### Finalize ###

    # exit to chroot mode
        exit