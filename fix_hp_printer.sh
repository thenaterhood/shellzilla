#!/bin/bash
#
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: fix_hp_printer.sh
#
# Description:
#   fixes an ownership issue with HP printers in older versions of
#   hplip so that the printer is usable.  Requires root.
#

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

# Check to make sure lsusb is available
depCheck lsusb

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
