#!/bin/bash

### Variables ###

configs=~/main/configs

### Set up links ###

    # profile
        ln -sf $configs/profile ~/.profile

    # zprofile 
        ln -sf $configs/zprofile ~/.zprofile
k
    # bash aliases
        # ln -sf $configs/bash_aliases ~/.bash_aliases

    # Xresources 
        ln -sf $configs/Xresources ~/.Xresources

    # bashrc 
        ln -sf $configs/bashrc ~/.bashrc

    # zshrc
        ln -sf $configs/zshrc ~/.zshrc

    # xinitrc 
        ln -sf $configs/xinitrc ~/.xinitrc
    
    # vim
        ln -sf $configs/vim/vimrc ~/.vimrc

    # i3
        mkdir -p ~/.config/i3
        ln -sf $configs/i3 ~/.config/i3/config
 
    # autokey
        ln -sf $configs/autokey ~/.config/autokey
        
    # ranger
        mkdir -p ~/.config/ranger
        ln -sf $configs/ranger/rifle.conf ~/.config/ranger/rifle.conf

    # vscode
        mkdir -p ~/.config/Code/User  
        ln -sf $configs/vscode_settings.json ~/.config/Code/User/settings.json
        ln -sf $configs/vscode_keybindings.json ~/.config/Code/User/keybindings.json

    # libinput
        sudo rm /usr/share/X11/xorg.conf.d/40-libinput.conf
        sudo ln -sf $configs/libinput.conf /usr/share/X11/xorg.conf.d/40-libinput.conf

    # fonts, themes, icons
        ln -sf ~/main/aesthetics/* ~/.local/share/.
        fc-cache -f -v

    # enable gtk aesthetic
        mkdir -p ~/.config/gtk-3.0
        ln -sf $configs/gtk-settings.ini ~/.config/gtk-3.0/settings.ini