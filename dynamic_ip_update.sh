#!/bin/bash
#
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: dynamic_ip_update.sh
#
# Description:
#   Fetches a URL to update the IP record of the system remotely
#   to keep the remote record of a dynamic Ip address up to date.
#
URL=
logFile=$HOME/dyndns.log

Error(){
    echo "`date`: ERROR: Could not update dynamic IP address" >> $logFile
}
Success(){
    echo "`date`: SUCCESS: Updated dynamic IP address to `curl icanhazip.com`" >> $logFile
}

curl $URL >/dev/null && Success || Error
