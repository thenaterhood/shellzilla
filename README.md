shellzilla
==========

A Collection of possibly-useful Linux shell scripts

Contents
------------

A collection of miscellaneous shell scripts for Linux, some useful, some not.
More descriptive information about each script can be found in the code
comments in the scripts themselves.

Contents:

    display_configurator.sh     A simple, semi-graphical script to set up basic multi-monitor settings
    devswitch.sh                A simple script to turn xinput devices on and off
    audio_ripper.sh             An ffmpeg-based script that rips/converts audio from files with given names or prefixes
    fix_hp_printer.sh           Fixes an ownership issue with HP printers on older HPLIP versions
    volumeControl.sh            Script to raise and lower volume and toggle mute. Useful in primitive WMs
    system_backup.sh            Script to backup a user directory or the Linux OS
    suspend.sh                  Simple script to lock the screen and suspend
    interest_calculator.sh      Script to calculate interest on a bank account over a period of time
    otf_multitouch.sh           Performs an on-the-fly configuration of touchpad multitouch settings
    batch_print.sh              Downloads and prints files en-masse from a defined url and list of files given
    dynamic_ip_update.sh        Checks the network's WAN address and pulls a URL to update it on a remote server.
    
Disclaimer
------------
If you break something with these, I take no responsibility for it.  Back up your stuff, check the code,
don't be dumb.

Installation
------------

To install the collection of scripts, you need to check out the repository
from github using

    git clone --recursive https://github.com/thenaterhood/shellzilla 
    
in the directory of your choosing (wherever you'd like the shellzilla folder to live).

followed by 
	
	cd shellzilla
	git submodule update --init --recursive
	
The --init flag initizlizes the submodule repositories and the --recursive flag
makes sure that nested submodules are initialized and updated as well.

You can update your copy with:

	cd ~/shellzilla
	git pull
	
You may want to learn more github commands in order to update specific files.

LICENSE
------------

Licensed under the BSD license. See LICENSE for full license text.

Though not required by the license terms, please consider contributing, 
providing feedback, or simply dropping a line to say that this software 
was useful to you.

thenaterhood/shellzilla (c) 2012-2014 Nate Levesque (TheNaterhood), [www.thenaterhood.com](http://www.thenaterhood.com)



thenaterhood/shellzilla repository (c) 2012-2014 Nate Levesque (TheNaterhood)
