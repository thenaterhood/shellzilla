#!/bin/bash
# 
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# Filename: batch_print.sh
#
# Description:
#   Downloads a list of files from a public folder and prints them.
#   The print_destination and baseUrl variables need to be set in the
#   script before using.  Not the cleanest code, but it works, was
#   originally used to print a group of documents via a remote mac.  When
#   run, it prompts the user for a comma-separated list of files to download
#   and print, then splits the list up around the commas into a file
#   and iterates through it, downloading and printing the files one at a
#   time.
#
########################################################################
# Settings                                                             #
########################################################################
baseUrl=http://www.thenaterhood.com/
print_destination=mcx_0
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
#
# Checking for required software
depCheck curl
depCheck lp

#
# Requesting list of files from the user
read -p "Comma separated filenames of the files to be printed, ie file1.pdf,file2.pdf: " files

#
# Creates a list of files
echo $files | sed -e 's/,/\
/g' > files.lst

#
# downloads and prints the files
for file in `cat files.lst`; do
	curl -O $baseUrl$file && lp -d "$print_destination" $file && echo "Downloaded and printed $file from $baseUrl" || echo "Could not print $file"

done
