#!/bin/bash
#
# Author: Nate Levesque <public@thenaterhood.com)
# Language: Shell
# Filename: audio_ripper.sh
#
# Description:
#   rips audio from a directory of video/audio files to .aac format
#
#

# Implement common code for dependency checks
depCheck(){
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

# Check that required software is available
depCheck ffmpeg

read -p "Name prefix for group of files or filename to rip: " prefix
echo "Ripping from files in `pwd`"

#
# Creates a directory to store the ripped audio
mkdir ripped-audio 2>/dev/null

#
# Checks to see if ls returns any files with the given prefix, if not
# informs the user and exits.
if [ "`ls | grep $prefix`" == "" ]; then
    echo "No files to rip."
    exit 0

else
    # Iterates through the directory and rips all the files that match
    # the given prefix
    for file in $prefix* ; do
        ffmpeg -i $file -acodec copy ripped-audio/$file.aac
    done
fi

# Asks the user whether or not to keep the source files
read -p "Keep source files? y/n: " keep

case $keep in
    "n"|"N")
    rm $prefix*
    echo "Removed source files."
    ;;
    
    "y"|"Y")
    echo "Kept source files"
    ;;
    
esac

exit 0
