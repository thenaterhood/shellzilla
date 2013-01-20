#!/bin/bash
#
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: dynamic_ip_update.sh
#
# Description:
#   Fetches a URL to update the IP record of the system remotely
#   in order to keep the remote record of a dynamic Ip address up to date.
#   Intended to be used as a cron or other schedule job, but can also
#   be run manually.
#
URL=
logFile=$HOME/dyndns.log

Error(){
    # Reflects an error retrieving the URL and logs it to the specified
    # logFile with the date and time
    echo "`date`: ERROR: Could not update dynamic IP address" >> $logFile
}
Success(){
    # Reflects success retrieving the URL and logs it as well as the
    # current IP address to the specified logFile with the date and time
    echo "`date`: SUCCESS: Updated dynamic IP address to `curl icanhazip.com`" >> $logFile
}

curl $URL >/dev/null && Success || Error
