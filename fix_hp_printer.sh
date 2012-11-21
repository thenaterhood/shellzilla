#!/bin/bash
#
#########################
# Nate Levesque
# 9/02/2011
# Script that fixes the HP printer ownership issue
#########################
#
# Checks to make sure required software is installed
if [ ! `command -v lsusb` ]; then
    echo "This script requires the lsusb utility. Exiting..."
    exit 1
fi

# Finds the bus and current HP device connected (if any)
bus=`lsusb | grep Hewlett-Packard | cut -c 5-7`
device=`lsusb | grep Hewlett-Packard | cut -c 16-18`
rootuser=root
# Finds the user who called the script
user=`whoami`
#
# Checks if the user calling the script was root and continues, 
# otherwise quits
if [ $user = $rootuser ]; then
    # Checks to see if an HP device is connected, quits if not
    if [ "`lsusb | grep Hewlett-Packard`" = "" ]; then
        echo "No HP device connected."
        exit 0
    else
        # Changes the ownership of the device to root:lp, which is
        # the correct ownership for the printer to work
        chown root:lp /dev/bus/usb/$bus/$device
        echo "Found HP device on /dev/bus/usb/$bus/$device"
        echo "Good to go!"
    exit
    fi
else
    # Informs the user that root is required and quits
    echo "Requires root privileges!"
    exit 1
fi
