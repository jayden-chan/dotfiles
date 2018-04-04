#!/bin/sh

RESULT=$(echo -e "logout\nlock\nreboot\nshutdown" | rofi -dmenu -i -p "power" -theme Custom-Nord -font "SF-Pro-Display 14" -lines 4 -width 25 -disable-history -tokenize)

if [ "$RESULT" = "logout" ]; then
    i3-msg 'exit'
elif [ "$RESULT" = "lock" ]; then
    exec betterlockscreen -l blur
elif [ "$RESULT" = "reboot" ]; then
    exec reboot
elif [ "$RESULT" = "shutdown" ]; then
    exec shutdown -h now
fi
