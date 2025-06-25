#!/usr/bin/env bash

if [ "$1" = "--power_fast" ]; then
    case $2 in
        logout)   echo 'awesome.quit()' | awesome-client ;;
        lock)     dm-tool lock ;;
        reboot)   shutdown --reboot now ;;
        shutdown) shutdown --poweroff now ;;
    esac
fi

if [ "$1" = "--normal" ]; then
    rofi -modi drun -show drun -drun-show-actions -theme base
elif [ "$1" = "--window" ]; then
    rofi -modi window -show window -theme base
elif [ "$1" = "--power" ]; then
    power_theme_str="listview { columns: 4; } window { width: 44%; }"
    result=$(< "$DOT/rofi/powermenu" rofi -dmenu -i -theme power -theme-str "$power_theme_str")

    case $result in
        logout)   echo 'awesome.quit()' | awesome-client ;;
        lock)     dm-tool lock ;;
        reboot)   shutdown --reboot now ;;
        shutdown) shutdown --poweroff now ;;
    esac
elif [ "$1" = "--liquidctl" ]; then
    result=$(< "$DOT/rofi/liquidctlmenu" rofi -dmenu -i -theme power)
    case $result in
        "Level 1") "$DOT/scripts/liquidctl.sh" "1" ;;
        "Level 2") "$DOT/scripts/liquidctl.sh" "2" ;;
        "Level 3") "$DOT/scripts/liquidctl.sh" "3" ;;
        "Level 4") "$DOT/scripts/liquidctl.sh" "4" ;;
        "Level 5") "$DOT/scripts/liquidctl.sh" "5" ;;
    esac
elif [ "$1" = "--save-screenshot" ]; then
    result=$(rofi -dmenu -i -p "title (no extension):")

    if [ "$result" = "" ]; then
        notify-send "Maim" "Screenshot not saved"
        exit
    fi

    file="$HOME/Pictures/Screenshots/$result.png"

    if [ -f "$file" ]; then
        notify-send "Error" "File $result.png already exists"
    else
        xclip -selection clipboard -t image/png -o > "$file"
        notify-send -i "$file" "Maim" "Screenshot saved to $result.png"
    fi
elif [ "$1" = "--autorandr" ]; then
    result=$(autorandr --list | rofi -dmenu -i -p "select profile:" -theme list)
    autorandr --load "$result"
fi
