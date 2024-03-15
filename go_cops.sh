#!/bin/bash

# ANSI Colors 
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  
ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  
WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"

# Check for sudo privileges
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Function to list USB devices
list_usb_devices() {
  lsblk -d -n -p -o NAME,MODEL | grep "/dev/sd"
}

check_device_presence() {
  if [ ! -e "$1" ]; then
    echo -e "${RED}The USB device has been unplugged." 
    sudo poweroff
    exit 1 
  fi
}

while true; do
  # Get USB device list with numbers using awk
  usb_devices_list=$(list_usb_devices | awk '{print NR, $0}')

  # Check if the usb_devices_list is empty
  if [ -z "$usb_devices_list" ]; then
    echo -e "${RED}No USB devices found. Please connect a USB device."
    sleep 2
    clear
    continue 
  fi
  clear

  echo -e "${RED}===================================================="
  echo -e "${RED} Remember, this is uselesss if you don't have       "
  echo -e "${RED} full disk encryption!            "
  echo -e "${RED}===================================================="

  # Print the numbered list
  echo ""
  echo -e "${GREEN}List of connected USB devices : " 
  echo "$usb_devices_list"

  # Ask the user to choose a device by number
  echo ""
  read -p "${CYAN}Enter the number of the USB device you want to select : " chosen_number 

  # Extract the selected USB device name using awk
  DEVICE=$(echo "$usb_devices_list" | awk -v chosen="$chosen_number" '$1 == chosen {print $2}')

  # Check if the user input is valid
  if [ -z "$DEVICE" ]; then
    echo ""
    echo -e "${RED}Invalid choice. Please enter a valid number from the list." 
    sleep 2
  else
    break 
  fi
done

# Confirmation 
echo ""
echo -e "${GREEN}You have chosen: $DEVICE"
sleep 02
clear

echo -e "${ORANGE}===================================================="
echo -e "${ORANGE}                     Monitoring                     "
echo -e "${ORANGE}===================================================="

while true; do
  check_device_presence "$DEVICE"
done