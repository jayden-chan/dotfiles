#!/usr/bin/env bash

while true; do
    coolant_temp=$(liquidctl --match Aquacomputer status --json | jq -c '.[0].status | .[] | select(.key | contains("Sensor 2")) | .value')
    if [ "$(echo "$coolant_temp >= 37.0" | bc -l)" = "1" ]; then
        ~/.config/dotfiles/scripts/liquidctl.sh "3" "true"
    fi

    sleep 60
done
