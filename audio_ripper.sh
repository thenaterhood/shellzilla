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
#
# Gets the name or the prefix for a group of video/audio files to be
# ripped or converted to .aac
read -p "Name prefix for group of files or filename to rip: " prefix
echo "Ripping from files in `pwd`"

#
# Checks to make sure ffmpeg is installed
if [ ! `command -v ffmpeg` ]; then
    echo "You need ffmpeg installed to use this script, exiting..."
    exit 1
fi

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
read -p "Keep original videos y/n? " keep
if [ $keep = n ]; then
    # If the user responds with n, erase the files and report it
    rm $prefix*
    echo "Erased..."
else
    # If the user responds with anything else, keep the files
    echo "Keeping..."
fi

exit 0
