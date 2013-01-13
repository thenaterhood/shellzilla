#!/bin/bash
#
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: devswitch.sh
#
# Description:
#   turns xinput devices on and off by checking their current status
#   and changing it to the opposite status.  Can be used by manually 
#   configuring the device ID variable or by using the device's name
#   by setting the device_name variable, in which case the script
#   finds the device id itself.  The script supports giving a device
#   name as an argument, but if none is given will fall back on the
#   pre-coded default value of "touchpad".
#
# Arguments:
#   name: the name of the device to toggle on or off
#
# Examples:
#   ./devswitch.sh trackpoint - toggle the thinkpad trackpoint on or off
#   ./devswitch.sh - toggle the default device on or off
#
########################################################################
# Settings section                                                     #
########################################################################
default_device=touchpad

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
    # Defines a common function the script can use for notification
    # on the console and the gui
    #
    export DISPLAY=:0.0 && notify-send \
    -i /usr/share/icons/gnome/scalable/devices/input-touchpad-symbolic.svg $device_name "$device_name $1"
    
    echo "$device_name is now $1"
}


# check that dependencies are satisfied
depCheck xinput

# Pick up any arguments given and use that, or fall back on the default
case "$1" in
    "")
    device_name=$default_device
    ;;
    
    *)
    device_name=$1
    ;;
esac


# Gets the device id for the device
deviceid=`xinput | grep -i $device_name | cut -d"=" -f2 | cut -c 1-2`

# Automatically discovers the device id of the touchpad.
# comment above and uncomment below to set it manually or to use a 
# different device
#deviceid=10

# Gets the current status of the device
status=`xinput list-props $deviceid | grep "Device Enabled" | cut -c 24`

# Changes it to the opposite status
case "$status" in
    1)
    xinput set-int-prop $deviceid "Device Enabled" 8 0
    # Notify the user the device was disabled
    notify disabled
    ;;
    
    0)
    xinput set-int-prop $deviceid "Device Enabled" 8 1
    # Notify the user the device was enabled
    notify enabled
    ;;
esac

exit 0
