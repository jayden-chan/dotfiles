#!/usr/bin/dash

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
elif [ "$1" = "--power" ]; then
    result=$(< "$HOME/.config/dotfiles/rofi/powermenu" rofi -dmenu -i -theme power -theme-str "$rofi_theme")

    case $result in
        logout)   echo 'awesome.quit()' | awesome-client ;;
        lock)     dm-tool lock ;;
        reboot)   shutdown --reboot now ;;
        shutdown) shutdown --poweroff now ;;
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
fi
