#!/bin/sh

if [ "$1" = "--normal" ]; then
    rofi -show drun -display-drun "run:" -show-icons -drun-icon-theme "Papirus" -theme theme -font "Nimbus Sans 14" -lines 5 -scroll-method 1
elif [ "$1" = "--power" ]; then
    RESULT=$(echo -e "logout\nlock\nreboot\nshutdown" | rofi -dmenu -i -p "power:" -theme theme -font "Nimbus Sans 14" -lines 4 -width 25 -disable-history -tokenize)

    case $RESULT in
        logout)
            echo 'awesome.quit()' | awesome-client
            ;;
        lock)
            dm-tool lock
            ;;
        reboot)
            reboot
            ;;
        shutdown)
            shutdown -h now
            ;;
    esac
fi

