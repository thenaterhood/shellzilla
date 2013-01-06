#!/bin/bash
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: volumeControl.sh
#
# Description:
#   Simple script to change the volume, useful to bind to keys in 
#   desktops/WMs that don't have their own control for it.
#
# Arguments:
#   (none): displays the current volume to the terminal and pops up
#       a notification with libnotify with the same info
#   up: raises the volume 5%
#   down: lowers the volume 5%
#   mute: mutes/unmutes the volume, prints it the console and shows a
#       libnotify notification
#
# Example:
#   ./volumeControl.sh mute - toggles mute
#   ./volumeControl.sh - shows current playback status
#   ./volumeControl.sh up - raise volume 5%
#
option=$1

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

notify(){
    # Provides a common way for the script to send notifications
    # to the user in the console and in the gui.
    #
    status="`amixer scontents | grep Playback | tail -2`"
    echo "$activity \n $status"
    export DISPLAY=:0.0 && notify-send \
    -i /usr/share/icons/gnome/scalable/devices/headphones-symbolic.svg "$activity" "$status"
}


# Performs the requested operation
case "$option" in
    "")
        activity="Playback Status"
        notify
        ;;
    up)
        amixer set Master 5%+ unmute
        activity="Volume Raised"
        #notify
        ;;
    down)
        amixer set Master 5%- unmute
        activity="Volume Lowered"
        #notify
        ;;
    mute)
        amixer set Master toggle
        activity="Volume Mute Toggled"
        notify
        ;;
esac
