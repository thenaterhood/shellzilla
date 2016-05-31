#!/bin/bash
#
# A data offloading/backup script based on rsync and tar
#
######################################
#             SETTINGS               #
######################################

ARCHIVE_TYPE="tgz"
# When run, you'll be presented with a list of locations here to offload to
MEDIA_MOUNTPOINT="/run/media/$USER"
# The path on the media to offload user data to. "/" is the root of the mountpt
# If creating an archive, it will be named with the current date
USER_PATH_ON_MEDIA="/backups/users/$USER"
# The path on the media to offload / data to
# If creating an archive, it will be named with the current date
ROOT_PATH_ON_MEDIA="/backups/os"

######################################
#            END SETTINGS            #
######################################
DAY=`date +%d`
MONTH=`date +%b`
YEAR=`date +%Y`

######################################
#             FUNCTIONS              #
######################################
checkForCommand(){
  # Simple check to make sure we have everything we expect to use
  # First argument (string) is checked for existence
  if [ ! `command -v $1` ]; then
      echo "You need $1 installed to use this script, exiting..."
      exit 1
  fi
}

askForAction(){
  backup_option=$(dialog --output-fd 1 --backtitle "Backup Options" --radiolist \
      "Select one:" 18 70 4 \
      1 "Rsync Home" off \
      2 "OS Image (requires root)" off \
      3 "Restore home from rsync" off \
      )

  if [ $backup_option ]; then
    echo $backup_option
  fi
}

askForBackupDrive(){

  drives=("$MEDIA_MOUNTPOINT"/*/)
  nDrives=${#drives[@]}
  iLastDrive=$[nDrives-1]

  drive_option_arr=()

  for i in `seq 0 $iLastDrive`; do
    currentDrive=$(printf %q ${drives[$i]})
    drive_option_arr+=("$i")
    drive_option_arr+=($currentDrive)
    drive_option_arr+=("off")
  done

  drive_num="$(dialog --output-fd 1 --backtitle "Backup" --radiolist \
      "Select device:" 18 70 12 ${drive_option_arr[@]})"

  if [ "$drive_num" ]; then
    echo ${drives[$drive_num]}
  fi
}

backupCompleted(){
    # Reports backup completed successfully by displaying a message
    # and appending the details to the backup info file
    #
    dialog --title "Backup Complete" \
    --msgbox "$1" 10 70;

    echo "Backup completed with no problems" > $backup_path/$backup_type/$backup_name/$info_file
    createInfo
}

backupCompletedWithErrors(){
    # Reports backup completed with errors by displaying a message
    # and appending the details to the backup info file
    #
    dialog --title "Backup Complete (with possible errors)" \
    --msgbox "Backup completed with errors; $1" 10 70;

    echo "Backup completed with errors" > $backup_path/$backup_type/$backup_name/$info_file
    createInfo
}

rsyncWithDialogProgress(){
  from="$1"
  to="$2"
  exclude_from="$3"

  rsync -aL --ignore-errors --info=progress2 --delete --delete-after \
      --recursive "$from" "$to" \
      --exclude-from $exclude_from 2>/dev/null | tr $'\r' $'\n' | awk '{ gsub("%", "", $2); print $2; system("") }' | dialog --title "Progress" --gauge "Rsync Progress ($from to $to)" 20 70
}

main(){
  checkForCommand dialog
  checkForCommand rsync
  checkForCommand awk
  checkForCommand tar

  backup_drive=`askForBackupDrive`
  [ $backup_drive ] || exit

  backup_action=`askForAction`
  [ $backup_action ] || exit

  case "$backup_action" in
      1)
          to=$backup_drive$USER_PATH_ON_MEDIA
          from=$HOME
          mkdir -p "$to"
          rsyncWithDialogProgress "$from" "$to" "$from/.exclude" && backupCompleted "Done!" || backupCompletedWithErrors "Some errors may have occurred while performing action"
          ;;
      2)
          # Create an image of the Linux root, minus /home and mounted drives
          backup_type="os"
          backup_name=`hostname`-$year-$month-$day
          to=$backup_drive$ROOT_PATH_ON_MEDIA/$backup_name
          mkdir -p "$to"
          sudo tar cvpzf $to \
              --exclude=/proc --exclude=/lost+found --exclude=/media \
              --exclude=/run --exclude=/mnt --exclude=/sys \
              --exclude=/dev/shm --exclude=/tmp --exclude=/home --exclude=/.btrfs / && backupCompleted "OS Tarball created" \
              || backupCompletedWithErrors "OS Tarball created, but may not be valid."
          ;;
      3)
          to=$HOME
          from=$backup_drive$USER_PATH_ON_MEDIA
          rsyncWithDialogProgress "$from" "$to" "$from/.exclude" && chown -R $USER $to && backupCompleted "Restore complete, enter when ready." || backupCompletedWithErrors "Restore may not have completed fully."
          ;;
  esac

}

main
