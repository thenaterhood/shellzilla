#!/bin/bash
#
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: suspend.sh
#
# Description:
#   Locks the screen and suspends.  Currently assumes slimlock is the
#   available screenlocker.  Simple script, cuts the number of steps
#   needed to lock and suspend if desktop controls or power management
#   don't work as expected.  Needs to be run from a terminal window.


echo "Locking and suspending for $USER, 5 seconds to cancel (ctrl+c)"
sudo sleep 5
slimlock & sudo pm-suspend
exit
