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

########################################################################
# Basic settings.  Set these before using the script                   #
########################################################################
ARCHIVE_TYPE=
FROM=
TO=
EXCLUDE_FILE=
LOG_FILE=
RESTORE=false
NONINVASIVE=false

usage()
{
   cat <<HERETO
   USAGE: backup --to TO --from FROM --type rsync|tgz
        [--exclude EXCLUDE_FILE] [--log LOG_FILE] [--restore] [--safe]

   --to                     Destination directory or archive filename
   --from                   Source directory to back up
   --type                   Type of archive. "tgz" "rsync" or "dry" for a dry run
   --exclude                List of locations to exclude from the backup. Defaults
                            to {FROM}/.exclude.
   --restore                Do a restore instead of a backup.
   --safe                   Don't verwrite existing files and don't delete non-existing ones.
                            This pertains to both backups and restores. Defaults to
                            disabled for legacy reasons.
HERETO
}

checkForCommand()
{ # $command
    # Checks if a piece of software exists on a system and
    # if it doesn't, stops execution and exits with an error.
    #
    # Arguments:
    #   $1: a command to test
    #
    if [ ! `command -v $1` ]; then
        echo "You need $1 installed to use this script, exiting..."
        exit 1
    fi
}

# Defining a few functions to use later
createInfoFile()
{ # $info_file
    # Appends information about the backup to the backup file
    # date, and a list of excluded files and folders
    #
    echo `date` > $1
    echo "Excluded:" >> $1
    [ -e "$EXCLUDE_FILE" ] && cat $EXCLUDE_FILE >> $1
}

logWrite()
{
  if [ ! -d "$TO" ]; then
    to_log="/dev/null"
  else
    to_log=$TO/$LOG_FILE
  fi

  if [ ! -d "$FROM" ]; then
    from_log="/dev/null"
  else
    from_log=$FROM/$LOG_FILE
  fi

  echo "[$(date)]: $1" | tee -a "$to_log" | tee -a "$from_log"
}

doBackup()
{
  logWrite "Starting backup, with options: ARCHIVE_TYPE=$ARCHIVE_TYPE, TO=$TO, FROM=$FROM, SAFE=$NONINVASIVE"
  logWrite "Excluding files from $EXCLUDE_FILE"
  case $ARCHIVE_TYPE in
    dry)
      logWrite "Dry run. No backup being done, but pretending we are."
      ;;
    rsync)
      if $NONINVASIVE; then
        rsync -aL --ignore-errors \
            --recursive "$FROM" "$TO" \
            --exclude-from "$EXCLUDE_FILE" --info=progress2 \
            && logWrite "Backup completed successfully" || logWrite "Backup completed with errors"
      else
        rsync -aL --ignore-errors --delete --delete-after \
            --recursive "$FROM" "$TO" \
            --exclude-from "$EXCLUDE_FILE" --delete-excluded --info=progress2 \
            && logWrite "Backup completed successfully" || logWrite "Backup completed with errors"
      fi
      exit 0
      ;;

    tgz)
      ext=$(echo $TO | rev | cut -d"." -f1 | rev | awk '{print tolower($0)}')
      [ "$ext" != "tgz" ] && [ "$ext" != "gz" ] && TO=$TO.
      tar -zcf "$TO" -C "$FROM" . \
          --exclude=/proc --exclude=/lost+found --exclude=/media \
          --exclude=/run --exclude=/mnt --exclude=/sys \
          --exclude=/dev/shm --exclude=/tmp --exclude=/home \
          && logWrite "Backup completed successfully" || logWrite "Backup completed with errors"
      ;;
    *)
      logWrite "Unsupported backup type $ARCHIVE_TYPE"
      exit 1
      ;;
  esac
}

doRestore()
{
  logWrite "Starting restore, with options: ARCHIVE_TYPE=$ARCHIVE_TYPE, TO=$TO, FROM=$FROM, SAFE=$NONINVASIVE"
  logWrite "Excluding files from $EXCLUDE_FILE"
  case $ARCHIVE_TYPE in
    dry)
      logWrite "Dry run. No restore being done, but pretending we are."
      ;;
    rsync)
      if $NONINVASIVE; then
        rsync -aL --ignore-errors \
            --recursive "$FROM" "$TO" \
            --exclude-from "$EXCLUDE_FILE" --info=progress2 \
            && logWrite "Restore completed successfully" || logWrite "Restore completed with errors"
      else
        rsync -aL --ignore-errors --delete --delete-after \
            --recursive "$FROM" "$TO" \
            --exclude-from "$EXCLUDE_FILE" --delete-excluded --info=progress2 \
            && logWrite "Restore completed successfully" || logWrite "Restore completed with errors"
      fi
      exit 0
      ;;

    tgz)
      mkdir -p "$TO"
      if $NONINVASIVE; then
        tar -xpzf "$FROM" -C "$TO" && logWrite "Restore completed successfully" || logWrite "Restore completed with errors"
      else
        tar -xpzf "$FROM" -C "$TO" --overwrite && logWrite "Restore completed successfully" || logWrite "Restore completed with errors"
      fi
      ;;
    *)
      logWrite "Unsupported restore type $ARCHIVE_TYPE"
      exit 1
      ;;
  esac

}

while [[ $# != 0 ]]; do
  case $1 in
    --to)
      TO=$2
      shift
      ;;
    --from)
      FROM=$2
      shift
      ;;
    --type)
      ARCHIVE_TYPE=$2
      shift
      ;;
    --exclude)
      EXCLUDE_FILE=$2
      shift
      ;;
    --restore)
      RESTORE=true
      ;;
    --safe)
      NONINVASIVE=true
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unrecognized option $1"
      usage
      exit 1
      ;;
    esac

    shift
done

[ -z $EXCLUDE_FILE ] && EXCLUDE_FILE=${FROM}/.exclude
[ ! -f $EXCLUDE_FILE ] && EXCLUDE_FILE=/dev/null

[ -z $LOG_FILE ] && LOG_FILE=".backuplog"

# Check that required software is installed
checkForCommand rsync
checkForCommand tar

if $RESTORE; then
  doRestore
else
  doBackup
fi
