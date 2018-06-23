#!/bin/sh

if [ "$1" = "--normal" ]; then
    rofi -show drun -display-drun "run:" -show-icons -drun-icon-theme "Papirus" -theme theme -font "Noto Sans 14" -lines 5 -width 50 -scroll-method 1
elif [ "$1" = "--power" ]; then
    RESULT=$(echo -e "logout\nlock\nreboot\nshutdown" | rofi -dmenu -i -p "power:" -theme theme -font "SF-Pro-Display 14" -lines 4 -width 25 -disable-history -tokenize)

    if [ "$RESULT" = "logout" ]; then
        i3-msg 'exit'
    elif [ "$RESULT" = "lock" ]; then
        dm-tool lock
    elif [ "$RESULT" = "reboot" ]; then
        exec reboot
    elif [ "$RESULT" = "shutdown" ]; then
        exec shutdown -h now
    fi
fi

