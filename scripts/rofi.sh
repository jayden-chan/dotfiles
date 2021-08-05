#!/usr/bin/dash

if [ "$1" = "--normal" ]; then
    rofi -modi drun -show drun -theme drun
elif [ "$1" = "--power" ]; then
    result=$(cat $HOME/Documents/Git/dotfiles/rofi/powermenu | rofi -dmenu -i -theme power)

    case $result in
        logout)   bspc quit ;;
        lock)     dm-tool lock ;;
        reboot)   shutdown --reboot now ;;
        shutdown) shutdown --poweroff now ;;
    esac
fi
