#!/usr/bin/env zsh

# if bluetooth is off we need to exit early because otherwise
# the bluetoothctl command hangs forever
active="$(systemctl status bluetooth | rg 'Active: active')"
if [ "$active" = "" ]; then
    exit 0
fi

device=$(bluetoothctl devices Connected | rg "^Device (.*?) $1$" --only-matching --replace='$1' --color=never)
if [ "$device" != "" ]; then
    bluetoothctl info "$device" | rg "Battery Percentage.*\((\d+)\)" --only-matching --replace='$1' --color=never
fi
