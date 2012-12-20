#!/bin/bash
#
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: devswitch.sh
#
# Description:
#   turns xinput devices on and off by checking their current status
#   and changing it to the opposite status.
#
########################################################################
# Settings section                                                     #
########################################################################
device_name=touchpad
# Gets the device id for the device
deviceid=`xinput | grep -i $device_name | cut -d"=" -f2 | cut -c 1-2`

# Automatically discovers the device id of the touchpad.
# comment above and uncomment below to set it manually or to use a 
# different device
#deviceid=10

# Gets the current status of the device
status=`xinput list-props $deviceid | grep "Device Enabled" | cut -c 24`

# Checks to make sure script dependencies are satisfied
if [ ! `command -v xinput` ]; then
    echo "You need to install xinput to use this script."
    exit 1
fi

# Defines a common function the script can use for notification
notify(){
    export DISPLAY=:0.0 && notify-send \
    -i /usr/share/icons/gnome/scalable/devices/input-touchpad-symbolic.svg $device_name "$device_name $change"
    
    echo "$device_name is now $change"
}
# Changes it to the opposite status
if [ "$status" = 1 ]; then
    xinput set-int-prop $deviceid "Device Enabled" 8 0
    change=disabled
    notify
    
elif [ "$status" = 0 ]; then
    xinput set-int-prop $deviceid "Device Enabled" 8 1
    change=enabled
    notify
fi

exit 0
