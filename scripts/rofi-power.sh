#!/bin/sh

RESULT=$(echo -e "logout\nreboot\nshutdown" | rofi -dmenu -i -p "power" -theme Custom-Nord -font "SF-Pro-Display 14" -lines 3 -width 25 -disable-history -tokenize)

if [ "$RESULT" = "logout" ];
then
    i3-msg 'exit'
elif [ "$RESULT" = "reboot" ];
then
    exec reboot
elif [ "$RESULT" = "shutdown" ];
then
    exec shutdown -h now
fi
