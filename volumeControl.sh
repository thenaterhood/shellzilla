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
#
option=$1

# Basic dependency check
if [ ! `command -v amixer` ]; then
    echo "You do not have amixer installed, this script requires it."
    exit 1
fi

# Defines a common notification function
notify(){
    status="`amixer scontents | grep Playback | tail -2`"
    export DISPLAY=:0.0 && notify-send \
    -i /usr/share/icons/gnome/scalable/devices/headphones-symbolic.svg "$activity" "$status"
}


# Performs the requested operation
case "$option" in
    "")
        echo "`amixer scontents | grep Playback | tail -2`"
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
        echo "Volume mute toggled"
        activity="Volume Mute Toggled"
        notify
        ;;
esac
