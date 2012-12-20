#!/bin/bash
#
#
# Backup Script
# Nate Levesque
# Last updated 03/17/2012
#
# This is online mainly to give me incentive to clean it up
# 
# TODO:  clean up everything and generally improve the code a lot
clear

# Sets appropriate variables
day=`date +%d`
month=`date +%b`
year=`date +%Y`
archive="tgz"
mountpt="/"
user="nate"

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

# Asks for the drive semi-graphically with dialog and 
dialog --backtitle "Backup" --msgbox "Mount media device and hit enter." 5 40
NUM=$(dialog --output-fd 1 --backtitle "Backup" --radiolist "Select device:" 12 40 4 0 /dev/null off `ls $mountpt | sed 's/ .*//g' | awk '{print NR " " $0 " off"}' | sed ':a;N;$!ba;s/\n/ /g'`)
echo $NUM
drive="`ls $mountpt | head -$NUM | tac | head -1`"

# Parses the data above into a filename for the backup
backup_name="$HOSTNAME-$month-$day-$year"
backup_file="$HOSTNAME-$month-$day-$year.$archive"
info_file="$HOSTNAME-$month-$day-$year.info"

# Moves us into the system root
cd /

# Asks what backup we want- rsync /home or tar /
backup_option=$(dialog --output-fd 1 --backtitle "Backup Options" --radiolist "Select one:" 12 40 4 1 "home sync" off 2 "OS image (requires root)" off)
echo $backup_option
backup_path="$mountpt/$drive/backups"

# Runs the actual backup- full partition backup
case "$backup_option" in
    1)
        backup_type="users"
        backup_name=$user
        info_file="$backup_name-HOME-$user.info"
        rsync -avhL --ignore-errors --delete --delete-after --recursive /home/$user/ $backup_path/$backup_type/$user/ --exclude-from /home/$user/.exclude --delete-excluded --progress
        exit 0
    ;;
    2)
        backup_type="os"
        mkdir $mountpt/$drive/backups/$backup_type/$backup_name
        tar cvpzf $backup_path/$backup_type/$backup_name/$backup_file --exclude=/proc --exclude=/lost+found --exclude=/media --exclude=/run --exclude=/mnt --exclude=/sys --exclude=/dev/shm --exclude=/tmp --exclude=/home /
    ;;
esac

# Creates the info file
echo `date` > $backup_path/$backup_type/$backup_name/$info_file
echo "Excluded:" >> $backup_path/$backup_type/$backup_name/$info_file
cat .exclude >> $backup_path/$backup_type/$backup_name/$info_file

# Informs us that everything is done
dialog --title "Backup Complete" --msgbox "Backup complete- backup set $backup_name" 10 30

# To Restore
# - From the rsync
# Software
# dpkg --set-selections < /media/Recovery/$DRV/$HOST/installed-software && dselect
# Files
# Just make users then replace /home with backup copy
# - TO RESTORE (from the tarball)
#  tar xvpfz backup.tgz -C /
exit 0

