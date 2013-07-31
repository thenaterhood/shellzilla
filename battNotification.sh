#!/bin/bash
#
#
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
    status="`acpi`"
    echo "$activity"
    echo "$status"
    export DISPLAY=:0.0 && notify-send \
    -i /usr/share/icons/gnome/scalable/status/battery-good-symbolic.svg "$activity" "$status"
}

depCheck acpi
activity="Battery Status"
notify



