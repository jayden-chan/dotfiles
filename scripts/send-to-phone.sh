#!/usr/bin/env bash
set -eou pipefail

device="$(kdeconnect-cli --list-devices --id-only)"

if [ "$device" = "" ]; then
    notify-send "send-to-phone" "Error: No device found"
    exit 1
fi

if [ "$1" = "" ]; then
    notify-send "send-to-phone" "Error: No file specified"
    exit 1
fi

if [ ! -f "$1" ]; then
    notify-send "send-to-phone" "Error: File $1 does not exist"
    exit 1
fi

kdeconnect-cli --device "$device" --share "$1"
notify-send "send-to-phone" "File sent"
