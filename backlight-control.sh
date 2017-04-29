#!/bin/bash
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: backlight-control.sh
#
# Description:
#   Simple script to change the backlight, useful in
#   desktops/WMs that don't have their own control for it.
#
# Arguments:
#   up: raises the backlight 5%
#   down: lowers the backlight 5%
#
# Example:
#   ./backlight-control.sh - shows current playback status
#   ./backlight-control.sh up - raise backlight 5%
#

INTERVAL=5

brightness=$(xbacklight -get)

case "$1" in
    "")
        ;;
    up)
        xbacklight -set $(($brightness+$INTERVAL))
        ;;
    down)
        xbacklight -set $(($brightness-$INTERVAL))
        ;;
esac

