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

#
# Checks to make sure script dependencies are satisfied
if [ ! `command -v xrandr` ]; then
    echo "You need to install xrandr to use this script."
    exit 1
fi

if [ ! `command -v dialog` ]; then
    echo "You need to install dialog to use this script."
    exit 1
fi

# Lists available ports (ones with something connected) in dialog and
# display options.  Returns them both to radioOptions, space separated

if [ `command -v dialog` ]; then
    radioOptions=$(dialog --output-fd 1 --backtitle "Available Display Ports" --radiolist "Select port:" 12 40 4 `xrandr | grep -w "connected" | sed 's/ .*//g' | awk '{print NR " " $0 " off"}' | sed ':a;N;$!ba;s/\n/ /g'`--and-widget --backtitle "Display Options" --radiolist "Select an option:" 12 40 4 1 "Extend" on 2 "Clone" off 3 "Switch display" off 4 "Normal display" off)
fi

#
# Sets relevant variables
number=`echo $radioOptions | cut -c 1`
disp_opt=`echo $radioOptions | cut -c 3`
exterior_port=`xrandr | grep -w "connected" | sed 's/ .*//g' | head -$number | tac | head -1`
builtin_monitor=$default_monitor
echo $disp_opt
echo $number
#
# Sets display option using xrandr
if [ "$disp_opt" = 1 ]; then
    # Extends the display to the right
    xrandr --output $exterior_port --off --output $builtin_monitor --auto &&
    xrandr --output $exterior_port --auto --output $builtin_monitor --auto --$monitor_direction-of $exterior_port
elif [ "$disp_opt" = 2 ]; then
    # Clones the display across both monitors
    xrandr --output $exterior_port --off --output $builtin_monitor --auto &&
    xrandr --output $exterior_port --auto
elif [ "$disp_opt" = 3 ]; then
    # Switches to the selected display
    xrandr --output $exterior_port --off --output $builtin_monitor --auto &&
    xrandr --output $builtin_monitor --off --output $exterior_port --auto
elif [ "$disp_opt" = 4 ]; then
    # Returns to the normal (builtin) display
    xrandr --output $exterior_port --off --output $builtin_monitor --auto
fi

clear
exit 0
