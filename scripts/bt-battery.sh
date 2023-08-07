#!/bin/zsh

device=$(bluetoothctl devices Connected | rg "^Device (.*?) $1$" --only-matching --replace='$1' --color=never)
if [ "$device" != "" ]; then
    bluetoothctl info "$device" | rg "Battery Percentage.*\((\d+)\)" --only-matching --replace='$1' --color=never
fi
