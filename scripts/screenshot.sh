#!/usr/bin/dash

if [ "$1" = "--select" ]; then
    maim --noopengl --capturebackground --select | xclip -selection clipboard -t image/png
else
    maim --noopengl | xclip -selection clipboard -t image/png
fi

notify-send "Maim" "Screenshot taken"
