shellzilla
==========

A Collection of possibly-useful Linux shell scripts

Contents
------------

A collection of miscellaneous shell scripts for Linux, some useful, some not.
At time of writing README, contents:

    display_configurator.sh     A simple, semi-graphical script to set up basic multi-monitor settings
    devswitch.sh                A simple script to turn xinput devices on and off
    audio_ripper.sh             An ffmpeg-based script that rips/converts audio from audio/video files with given names or prefixes
    
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

After you've downloaded and initialized the repository, you can link the
configuration files to their proper locations using the commands below.
These commands create a symlink in the proper location that points to the repository
on your computer.  You can update your dot-conf by running

	cd ~/shellzilla
	git fetch
	git pull
	
You may want to learn more github commands in order to update specific files.

LICENSE
------------

thenaterhood/shellzilla repository (c) 2012 Nate Levesque (TheNaterhood)

[![Creative Commons License](http://i.creativecommons.org/l/by-sa/3.0/88x31.png)](http://creativecommons.org/licenses/by-sa/3.0/)

TL;DR: You can use, copy and modify this SO LONG AS you credit me and distribute your remixes with the same license.

This work is licensed under the [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).

You should have received a copy of the license along with this
work. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ or send
a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
