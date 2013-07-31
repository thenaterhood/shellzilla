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
show="n"

# If we're automatically running the script
# let's not spam the user, only tell them if
# there is a reason or if no arguments
case $1 in
	"auto")
	if [ `acpi | cut -d"," -f2 | cut -c 2-3` -lt 25 ]; then show="y"; fi
	;;
	"")
	show=""
	;;
esac


if [ $show="y" ]; then	
	activity="Battery Status"
	if [ `acpi | cut -d"," -f2 | cut -c 2-3` -lt 25 ]; then activity="Battery under 25%"; fi
	if [ `acpi | cut -d"," -f2 | cut -c 2-3` -lt 20 ]; then activity="BATTERY LOW"; fi

	notify
fi



