#!/bin/bash
#
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: system_backup.sh
#
# Description:
#   Basic script that implements a couple of backups
#   for user files and the OS.  Might require a couple changes
#   in the Basic Settings section depending on your setup.
#
# This is online mainly to give me incentive to clean it up
# 
# TODO:  clean up everything and generally improve the code a lot
clear

########################################################################
# Basic settings.  Set these before using the script                   #
########################################################################
archive="tgz"
mountpt="/run/media/$USER"

# Sets appropriate variables
day=`date +%d`
month=`date +%b`
year=`date +%Y`

# Defining a few functions to use later
createInfo(){
    # Appends information about the backup to the backup file
    # date, and a list of excluded files and folders
    echo `date` >> $backup_path/$backup_type/$backup_name/$info_file
    echo "Excluded:" >> $backup_path/$backup_type/$backup_name/$info_file
    cat .exclude >> $backup_path/$backup_type/$backup_name/$info_file
}

completed(){
    # Reports backup completed successfully
    dialog --title "Backup Complete" \
    --msgbox "Backup complete- backup set $backup_name" 10 30;
    
    echo "Backup completed with no problems" > $backup_path/$backup_type/$backup_name/$info_file
    createInfo
}

completedWithErrors(){
    # Reports backup completed with errors
    dialog --title "Backup Complete (with errors)" \
    --msgbox "Backup completed with errors- backup set $backup_name" 10 30;
    
    echo "Backup completed with errors" > $backup_path/$backup_type/$backup_name/$info_file
    createInfo
}

# Implements a few basic dependency checks
if [ ! `command -v dialog` ]; then
    echo "Dialog is not installed, and is required for this script. Exiting..."
    exit 1
fi

if [ ! `command -v rsync` ]; then
    echo "rsync is not installed, and is required for this script. Exiting..."
    exit 1
fi

if [ ! `command -v tar` ]; then
    echo "tar is not installed, and is required for this script.  Exiting..."
    exit 1
fi

# Asks for the backup drive semi-graphically with dialog
dialog --backtitle "Backup" --msgbox "Mount media device and hit enter." 5 40
NUM=$(dialog --output-fd 1 --backtitle "Backup" --radiolist \
    "Select device:" 12 40 4 0 /dev/null off `ls $mountpt | sed 's/ .*//g' \
    | awk '{print NR " " $0 " off"}' | sed ':a;N;$!ba;s/\n/ /g'`)

drive="`ls $mountpt | head -$NUM | tac | head -1`"

# Pieces together filenames for the backup and info
backup_name="$HOSTNAME-$month-$day-$year"
backup_file="$HOSTNAME-$month-$day-$year.$archive"
info_file="$HOSTNAME-$month-$day-$year.info"

# Moves into the system root
cd /

# Ask what backup to perform- rsync /home/$USER or tarball OS
backup_option=$(dialog --output-fd 1 --backtitle "Backup Options" --radiolist \
    "Select one:" 12 40 4 1 "home sync" off 2 "OS image (requires root)" off)

backup_path="$mountpt/$drive/backups"



# Runs the actual backup
case "$backup_option" in
    1)
        backup_type="users"
        backup_name=$USER
        info_file="$backup_name-backup.info"
        rsync -avhL --ignore-errors --delete --delete-after \
            --recursive /home/$USER/ $backup_path/$backup_type/$USER/ \
            --exclude-from /home/$USER/.exclude --delete-excluded --progress && completed\
            || completedWithErrors
        ;;
    2)
        backup_type="os"
        mkdir $mountpt/$drive/backups/$backup_type/$backup_name
        sudo tar cvpzf $backup_path/$backup_type/$backup_name/$backup_file \
            --exclude=/proc --exclude=/lost+found --exclude=/media \
            --exclude=/run --exclude=/mnt --exclude=/sys \
            --exclude=/dev/shm --exclude=/tmp --exclude=/home / && completed\
            || completedWithErrors
        ;;
esac

# To Restore
# Files
# Just make users then replace /home with backup copy. Permission 
# problems may apply
# - TO RESTORE (from the tarball)
#  tar xvpfz backup.tgz -C /
exit 0

