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


user=`whoami`
echo "Locking and suspending for $user, 5 seconds to cancel (ctrl+c)"
sleep 5
sudo pm-suspend &
su -c slimlock $user
exit
