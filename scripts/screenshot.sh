#!/bin/sh

if [ "$1" = "--window" ]; then
    maim --noopengl --window=$(xdotool getactivewindow) | xclip -selection clipboard -t image/png
else
    maim --noopengl --capturebackground --select | xclip -selection clipboard -t image/png
fi

notify-send "Maim" "Screenshot taken"
