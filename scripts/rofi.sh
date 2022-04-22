#!/usr/bin/dash

is_minecraft=$(xdotool getwindowname $(xdotool getwindowfocus) | rg --ignore-case "(minecraft)|(Team Fortress 2)")

# don't open rofi while in minecraft
if [ "$is_minecraft" != "" ]; then
    exit
fi

if [ "$1" = "--normal" ]; then
    rofi -modi drun -show drun -theme drun
elif [ "$1" = "--power" ]; then
    result=$(cat $HOME/.config/dotfiles/rofi/powermenu | rofi -dmenu -i -theme power)

    case $result in
        logout)   bspc quit ;;
        lock)     dm-tool lock ;;
        reboot)   shutdown --reboot now ;;
        shutdown) shutdown --poweroff now ;;
    esac
elif [ "$1" = "--save-screenshot" ]; then
    result=$(rofi -dmenu -i -theme screenshot -p "file name:")

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
fi
