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
URL==
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
CheckIP(){
    # Figures out the previous IP address update by looking at the log file, and exits if it is
    # the same as the current one, reflecting this in the log
    lastIP=`awk '/SUCCESS/ { save=$NF }END{ print save }' $logFile 2>/dev/null`
    currIP=`curl -s --connect-timeout 5 icanhazip.com`
    
    # Checks if a logfile exists and if the last and current IP's are the same,
    # and pulls the url if either happens to not be the case.
    if [ ! "$lastIP" = "$currIP" ] || [ ! -e $logFile ]; then
        curl -s --connect-timeout 5 $URL && Success || Error
    else
        echo "`date`: OK: IP address ($currIP), has not changed since last check." >> $logFile
    fi
}

# Runs the whole thing
CheckIP 
