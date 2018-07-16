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
    sudo dd bs=4M if=$HOME/downloads/arch.iso of=/dev/$drive oflag=sync status=progress

# create a new partition
    sudo fdisk /dev/$drive 

# format the new partition
    sudo mkfs.ext4 /dev/${drive}3

# mount the partition
    sudo mkdir -p /mnt/$personaldir
    sudo mount /dev/${drive}3 /mnt/$personaldir

# copy home directories onto the partition
    while read -r dir; do
        sudo cp -r ~/$dir /mnt/$personaldir    
    done < ~/configs/personal_folders.txt

# unmount the partition
    sudo umount /mnt/$personaldir