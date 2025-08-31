#!/usr/bin/env bash

accel_prop="libinput Accel Speed"
accel_speed="-0.80"

if [ "$1" = "--cs2" ]; then
    accel_speed="-1"
fi

declare -a mice=("Razer Razer Viper V2 Pro" "WL WLMOUSE BEAST X PRO 8K RECEIVER" "2.4G Wireless Mouse")

for mouse in "${mice[@]}"; do
    for id in $(xinput | rg "$mouse" | rg "pointer" | rg "id=(\d+)" --color=never --only-matching --replace='$1'); do
        xinput --list-props "$id" | rg "$accel_prop" >/dev/null 2>&1 \
            && echo "xinput --set-prop $id $accel_prop $accel_speed" \
            && xinput --set-prop "$id" "$accel_prop" "$accel_speed"
    done
done

if [ "$1" = "--mouse-only" ]; then
    exit 0
fi

numlockx on
killall picom
"$DOT/scripts/liquidctl.sh" 4
sleep 5
notify-send --urgency=critical "gpu-screen-recorder" "Enable GPU screen recorder"
notify-send --urgency=critical "sensors-mon" "Remove computer top panel"
