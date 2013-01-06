#!/bin/bash
#
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: display_configurator.sh
#
# Description:
#   Deals with extending or cloning the desktop between the internal 
#   and 1 external monitor using xrandr
#

#
# Basic options.  Set the direction of your extra screen and main screen
monitor_direction=left
default_monitor=LVDS1

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

normalDisplay(){
    # Switches to the normal/default display, desktop on main screen
    # and externals off.
    #
    xrandr --output $exterior_port --off --output $builtin_monitor --auto
}

#
# Checks to make sure script dependencies are satisfied
depCheck xrandr
depCheck dialog

# Lists available ports (ones with something connected) in dialog and
# display options.  Returns them both to radioOptions, space separated

# Why this is checking for dialog I have no idea, probably
# had plans so leaving it for now, doesn't hurt anything
if [ `command -v dialog` ]; then
    radioOptions=$(dialog --output-fd 1 --backtitle "Available Display Ports" --radiolist "Select port:" 12 40 4 `xrandr | grep -w "connected" | sed 's/ .*//g' | awk '{print NR " " $0 " off"}' | sed ':a;N;$!ba;s/\n/ /g'`--and-widget --backtitle "Display Options" --radiolist "Select an option:" 12 40 4 1 "Extend" on 2 "Clone" off 3 "Switch display" off 4 "Normal display" off)
fi

#
# Picks up the monitor selected in dialog
number=`echo $radioOptions | cut -c 1`

# Picks up the option selected in dialog
disp_opt=`echo $radioOptions | cut -c 3`

# Finds the exterior monitor's port (monitor to switch/extend to)
exterior_port=`xrandr | grep -w "connected" | sed 's/ .*//g' | head -$number | tac | head -1`

# Finds the builtin/default monitor
builtin_monitor=$default_monitor

#
# Sets display option using xrandr

case "$disp_opt" in
    1)
    # Extends the display to the right
    normalDisplay
    xrandr --output $exterior_port --auto --output $builtin_monitor --auto --$monitor_direction-of $exterior_port
    ;;
    
    2)
    # Clones the display across both monitors
    normalDisplay
    xrandr --output $exterior_port --auto
    ;;
    
    3)
    # Switches to the selected display
    normalDisplay
    xrandr --output $builtin_monitor --off --output $exterior_port --auto
    ;;
    
    4)
    # Returns to the normal (builtin) display
    normalDisplay
    ;;
esac

clear
exit 0
