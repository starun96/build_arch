#!/bin/bash

# load usb with arch iso

drive=$1
if [[ -z $drive ]]; then 
    echo "Incorrect # of args"
    exit
fi
personaldir=personal

sudo dd bs=4M if=$HOME/downloads/arch.iso of=/dev/$drive oflag=sync status=progress
sudo fdisk /dev/$drive # (create a new partition)
sudo mkfs.ext4 /dev/${drive}3
sudo mkdir -p /mnt/$personaldir
sudo mount /dev/${drive}3 /mnt/$personaldir

declare -a dir_list=(
    aesthetic
    coding
    configs
    documents
    downloads
    media
    music
    notes
    school
    scripts
)

for dir in ${dir_list[@]}; do
    sudo cp -r $HOME/$dir /mnt/$personaldir
done

sudo umount /mnt/$personaldir