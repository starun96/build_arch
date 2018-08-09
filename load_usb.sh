#!/bin/bash

# vars
    personaldir=personal

# setting up target drive
    drive=$1
    if [[ -z $drive ]]; then 
        echo "Incorrect # of args"
        exit
    fi

# load ISO onto the drive
    sudo dd bs=4M if=$HOME/main/downloads/arch.iso of=/dev/$drive oflag=sync status=progress