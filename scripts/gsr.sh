#!/bin/bash

while true; do
    focused_window=$(xdotool getwindowfocus getwindowname)

    if [ "$focused_window" = "Counter-Strike 2" ]; then
        pid=$(pgrep gpu-screen-reco)
        if [ "$pid" = "" ]; then
            notify-send -u critical "gpu-screen-recorder" "WARNING: gpu-screen-recorder isn't running"
        else
            tail --pid="$pid" -f /dev/null
        fi
    fi

    coolant_temp=$(liquidctl --match Aquacomputer status --json | jq -c '.[0].status | .[] | select(.key | contains("Sensor 2")) | .value')
    if [ "$(echo "$coolant_temp >= 37.0" | bc -l)" = "1" ]; then
        ~/.config/dotfiles/scripts/liquidctl.sh "3" "true"
    fi

    sleep 60
done
