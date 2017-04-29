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

MIXER_COMMAND_VOLUME_UP=true
MIXER_COMMAND_TOGGLE_MUTE=true
MIXER_COMMAND_VOLUME_DOWN=true

if which amixer &> /dev/null; then
    MIXER_COMMAND_VOLUME_UP="amixer set Master 5%+"
    MIXER_COMMAND_VOLUME_DOWN="amixer set Master 5%-"
    MIXER_COMMAND_TOGGLE_MUTE="amixer set Master toggle"
fi

if which pamixer &> /dev/null; then
    MIXER_COMMAND_VOLUME_UP="pamixer -i 5"
    MIXER_COMMAND_VOLUME_DOWN="pamixer -d 5"
    MIXER_COMMAND_TOGGLE_MUTE="pamixer -t"
fi

case "$1" in
    "")
        ;;
    up)
        $MIXER_COMMAND_VOLUME_UP
        ;;
    down)
        $MIXER_COMMAND_VOLUME_DOWN
        ;;
    mute)
        $MIXER_COMMAND_TOGGLE_MUTE
        ;;
esac

