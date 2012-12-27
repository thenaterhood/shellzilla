#!/bin/bash
#
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: otf_multitouch.sh
#
# Description:
#   Enables and configures a bunch of common multitouch settings for
#   a synaptic touchpad.  Enables two-finger scrolling, circular (ipod)
#   scrolling, palm detection, and "natural" scrolling (changes the
#   scrolling direction to match that of a touchscreen).  Uses xinput
#   to configure these on the fly, so it isn't persistent through logout.
#   Useful in situations where these options are desired but can't be
#   configured system-wide if there isn't root access.
#

# A quick dependency check so the program can fail gracefully if things
# happen to be missing
if [ ! `command -v xinput` ]; then
    echo "Xinput is not available but is required for this script."
    exit 1
fi

# Sets the properties
sleep 5
# Enables 2-finger scrolling and related settings (will emulate 2-fingers
# if touchpad is not true multitouch)
xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Two-Finger Scrolling" 8 1
xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Two-Finger Scrolling" 8 1 1
xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Two-Finger Pressure" 32 10
xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Two-Finger Width" 32 8
# Enables circular (ipod) scrolling and related settings
xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Circular Scrolling" 8 1
xinput set-prop --type=float "SynPS/2 Synaptics TouchPad" "Synaptics Circular Scrolling Distance" 0.4
# Enables palm detection
xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Palm Detection" 8 1
# Changes scrolling direction (for standard direction, remove the negative sign)
xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Scrolling Distance" 32 -110 110
exit 0
