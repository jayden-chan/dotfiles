#!/usr/bin/dash

font="Nimbus Sans 14"

if [ "$1" = "--normal" ]; then
    rofi -modi drun -show drun -display-drun "run:" -show-icons -icon-theme "Yaru-Blue" -theme default -font "$font" -lines 5 -scroll-method 1
elif [ "$1" = "--power" ]; then
    RESULT=$(echo "logout\nlock\nreboot\nshutdown" | rofi -dmenu -i -p "power:" -theme default -font "$font" -lines 4 -width 25 -disable-history -tokenize)

    case $RESULT in
        logout)
            bspc quit
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
