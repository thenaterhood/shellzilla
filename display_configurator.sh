#!/bin/bash
#
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: display_configurator.sh
#
# Description:
# Deals with extending or cloning the desktop 
# between the internal and 1 external monitor 
# with xrandr.  Has 3 possible interfaces.  No argument,
# missing dialog/zenity, or no display variable set results
# in a console interface.  Arguments dialog and zenity 
# open the configurator with the requested interface if it is
# available on the system (falls back to console).  When binding
# to a key command, to use the dialog or console interface you
# must open it in a terminal emulator.
#
# Arguments:
#   (dialog): attempt to use the dialog package for an interface
#   (zenity): attempt to use zenity to provide an interface
#   none:   use the console interface
#
# Examples:
#   ./display_configurator.sh - uses the console interface
#   ./display_configurator.sh dialog - uses the dialog interface
#
# Dependencies:
#   Xrandr
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
    echo -e "Reseting display..."
    xrandr --output $exterior_port --off --output $builtin_monitor --auto
}

exitIfEmpty(){
    # Checks to see if a variable is empty, and if it is
    # echos the message in the second argument and exits
    if [ "$1" == "" ]; then
        echo $2
        exit 1
    fi
}

depCheck xrandr

#
# Decides what menu system to use (dialog, xmessage, or zenity for now)
MENU=console
if  [ "$1" == "dialog" ] && [ `command -v dialog` ] && [ "$DISPLAY" != "" ]; then
    MENU=dialog
fi
if  [ "$1" == "zenity" ] && [ `command -v zenity` ] && [ "$DISPLAY" != "" ]; then
    MENU=zenity
fi

#
# Lists available ports (ones with something connected) in dialog and
# display options.  Returns them both to radioOptions, space separated
case $MENU in
    dialog)
        # Uses dialog to present graphical menus for setting simple multimonitor
        # options
        radioOptions=$(dialog --output-fd 1 --backtitle "Available Display Ports" --radiolist "Select port:" 12 40 4 `xrandr | grep -w "connected" | sed 's/ .*//g' | awk '{print NR " " $0" off"}' | sed ':a;N;$!ba;s/\n/ /g'`--and-widget --backtitle "Display Options" --radiolist "Select an option:" 12 40 4 1 "Extend" on 2 "Clone" off 3 "Switch display" off 4 "Normal display" off)
        ;;
        
    zenity)
        # Uses zenity to present graphical menus for setting simple multimon
        # settings
        port=$(zenity  --list --width=300 --height=200 --title "Display Configurator: Select output" --text "Available Display Ports" --radiolist  --column "Select" --column "Port" `xrandr | grep -w "connected" | sed 's/ .*//g' | awk '{print "FALSE " NR ":"$0 }' | sed ':a;N;$!ba;s/\n/ /g'`)
        exitIfEmpty "$port" "Cancelled."

        displayOpt=$(zenity  --list --width=300 --height=200 --title "Display Configurator: Choose option" --text "Available Display Ports" --radiolist  --column "Select" --column "Port" TRUE "1: Extend" FALSE "2: Clone" FALSE "3: Switch display" FALSE "4: Normal display")
        exitIfEmpty "$displayOpt" "Cancelled."
        
        radioOptions=$(echo $port | cut -c 1),$(echo $displayOpt | cut -c 1)
        echo $radioOptions
        ;;
    console)
        # A final, desperate attempt to present the settings to the user
        export DISPLAY=:0.0
        echo "Display Configurator.
        "
        echo -e `xrandr | grep -w "connected" | sed 's/ .*//g' | awk '{print NR " " $0}'`
        read -p "Choose an available port: " port
        echo "
        1: Extend 
        2: Clone 
        3: Switch display 
        4: Normal Display"
        read -p "Choose an option: " displayOpt
        
        radioOptions=$(echo $port | cut -c 1),$(echo $displayOpt | cut -c 1)

        ;;
esac


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
    echo -e "Extending display..."
    xrandr --output $exterior_port --auto --output $builtin_monitor --auto --$monitor_direction-of $exterior_port
    ;;
    
    2)
    # Clones the display across both monitors
    normalDisplay
    echo -e "Cloning output..."
    xrandr --output $exterior_port --auto
    ;;
    
    3)
    # Switches to the selected display
    normalDisplay
    echo -e "Switching display..."
    xrandr --output $builtin_monitor --off --output $exterior_port --auto
    ;;
    
    4)
    # Returns to the normal (builtin) display
    normalDisplay
    ;;
esac

#clear
exit 0
