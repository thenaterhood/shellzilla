#!/bin/bash
# Author: Nate Levesque <public@thenaterhood.com>
# Language: BASH
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

# Performs the requested operation
case "$option" in
    "")
        echo "`amixer scontents | grep Playback | tail -2`"
        notify-send -i /usr/share/icons/gnome/32x32/status/audio-volume-high.png "`amixer scontents | grep Playback | tail -2`" 2>/dev/null
        ;;
    up)
        amixer set Master 5%+ unmute
        ;;
    down)
        amixer set Master 5%- unmute
        ;;
    mute)
        amixer set Master toggle
        echo "Volume mute toggled"
        notify-send -i /usr/share/icons/gnome/32x32/status/audio-volume-high.png "Volume Mute Toggled" 2>/dev/null
        ;;
esac
