#!/bin/bash

while true; do
    focused_window=$(xdotool getwindowfocus getwindowname)

    if [ "$focused_window" = "Counter-Strike 2" ]; then
        pid=$(pgrep gpu-screen)
        if [ "$pid" = "" ]; then
            notify-send -u critical "gpu-screen-recorder" "WARNING: gpu-screen-recorder isn't running"
        else
            tail --pid="$pid" -f /dev/null
        fi
    fi

    sleep 30
done
