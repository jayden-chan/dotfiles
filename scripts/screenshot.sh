#!/usr/bin/dash

if [ "$1" = "--window" ]; then
    maim --noopengl | xclip -selection clipboard -t image/png
    # maim --noopengl --window=$(xdotool getactivewindow) | xclip -selection clipboard -t image/png
else
    maim --noopengl --capturebackground --select | xclip -selection clipboard -t image/png
fi

notify-send "Maim" "Screenshot taken"
