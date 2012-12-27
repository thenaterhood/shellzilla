#!/bin/bash
#
# Author: Nate Levesque <public@thenaterhood.com>
# Language: Shell
# File: interest_calculator.sh
# 
# Description:
#   A simple script to calculate interest on a bank account over a period
#   of time.  Optionally will also save the information to a file.
#
clear
echo "Interest calculation"
echo "Output to file?"

read -p "[Y]es or [N]o: " save_to_file

# Set up where "file" output goes, either /dev/null or an actual file
case "$save_to_file" in
    "n"|"N")
    outfile=/dev/null
    ;;
    
    "y"|"Y")
    read -p "Save where? (full path if not in running directory): " outfile
    ;;
esac

# Request the necessary information from the user
read -p "Starting Amount: $" P
read -p "Rate (decimal): " R
read -p "Times Compounded (in the period we're calculating): " N
read -p "Time in years: " T
# Formula is P(1+R/N)^(NT)

# Output the data and calculation to the console and the file (if saving)
echo "Starting amount: $P; Rate: $R; Times Compounded: $N; Time in years: $T;" > $outfile
echo "===========================================" | tee -a $outfile
echo "Resulting amount" | tee -a $outfile
echo "($P*e(($N*$T)*l(1+$R/$N)))" | bc -l | awk '{print ($1+0.00)}' | tee -a $outfile
echo "Gain" | tee -a $outfile
echo "($P*e(($N*$T)*l(1+$R/$N)))-$P" | bc -l | awk '{print ($1+0.00)}' | tee -a $outfile
echo "==========================================="
exit 0
