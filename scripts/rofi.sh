#!/usr/bin/env bash

[ -e "$HOME/.config/ENV" ] && . "$HOME"/.config/ENV

if [ "$STRIPE_COLOR" != "" ] && [ "$BORDER_COLOR" != "" ]; then
    rofi_theme="* { stripe: $STRIPE_COLOR; border: $BORDER_COLOR; }"
else
    rofi_theme=""
fi

if [ "$1" = "--power_fast" ]; then
    case $2 in
        logout)   echo 'awesome.quit()' | awesome-client ;;
        lock)     dm-tool lock ;;
        reboot)   shutdown --reboot now ;;
        shutdown) shutdown --poweroff now ;;
    esac
fi

if [ "$1" = "--normal" ]; then
    rofi -modi drun -show drun -drun-show-actions -theme drun -theme-str "$rofi_theme"
elif [ "$1" = "--window" ]; then
    rofi -modi window -show window -theme drun -theme-str "$rofi_theme"
elif [ "$1" = "--power" ]; then
    result=$(< "$HOME/.config/dotfiles/rofi/powermenu" rofi -dmenu -i -theme power -theme-str "$rofi_theme")

    case $result in
        logout)   echo 'awesome.quit()' | awesome-client ;;
        lock)     dm-tool lock ;;
        reboot)   shutdown --reboot now ;;
        shutdown) shutdown --poweroff now ;;
    esac
elif [ "$1" = "--liquidctl" ]; then
    result=$(< "$HOME/.config/dotfiles/rofi/liquidctlmenu" rofi -dmenu -i -theme power -theme-str "$rofi_theme" -theme-str "listview { columns: 5; }")
    case $result in
        "Level 1") "$HOME/.config/dotfiles/scripts/liquidctl.sh" "1" ;;
        "Level 2") "$HOME/.config/dotfiles/scripts/liquidctl.sh" "2" ;;
        "Level 3") "$HOME/.config/dotfiles/scripts/liquidctl.sh" "3" ;;
        "Level 4") "$HOME/.config/dotfiles/scripts/liquidctl.sh" "4" ;;
        "Level 5") "$HOME/.config/dotfiles/scripts/liquidctl.sh" "5" ;;
    esac
elif [ "$1" = "--save-screenshot" ]; then
    result=$(rofi -dmenu -i -theme screenshot -p "file name:" -theme-str "$rofi_theme")

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
    result=$(autorandr --list | rofi -dmenu -i -p "select profile:" -theme links -theme-str "$rofi_theme")
    autorandr --load "$result"
fi
