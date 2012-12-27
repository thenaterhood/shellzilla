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

# Pick up any arguments given and use that, or fall back on the default
case "$1" in
    "")
    device_name=$default_device
    ;;
    
    *)
    device_name=$1
    ;;
esac

# Checks to make sure script dependencies are satisfied
if [ ! `command -v xinput` ]; then
    echo "You need to install xinput to use this script."
    exit 1
fi

# Gets the device id for the device
deviceid=`xinput | grep -i $device_name | cut -d"=" -f2 | cut -c 1-2`

# Automatically discovers the device id of the touchpad.
# comment above and uncomment below to set it manually or to use a 
# different device
#deviceid=10

# Gets the current status of the device
status=`xinput list-props $deviceid | grep "Device Enabled" | cut -c 24`

# Defines a common function the script can use for notification
notify(){
    export DISPLAY=:0.0 && notify-send \
    -i /usr/share/icons/gnome/scalable/devices/input-touchpad-symbolic.svg $device_name "$device_name $change"
    
    echo "$device_name is now $change"
}

# Changes it to the opposite status
case "$status" in
    1)
    xinput set-int-prop $deviceid "Device Enabled" 8 0
    change=disabled
    notify
    ;;
    
    0)
    xinput set-int-prop $deviceid "Device Enabled" 8 1
    change=enabled
    notify
    ;;
esac

exit 0
