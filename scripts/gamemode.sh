#!/usr/bin/env bash

accel_prop="libinput Accel Speed"
accel_speed="-0.80"

declare -a mice=("Razer Razer Viper V2 Pro" "WL WLMOUSE BEAST X PRO 8K RECEIVER" "2.4G Wireless Mouse")

for mouse in "${mice[@]}"; do
    for id in $(xinput | rg "$mouse" | rg "pointer" | rg "id=(\d+)" --color=never --only-matching --replace='$1'); do
        xinput --list-props "$id" | rg "$accel_prop" >/dev/null 2>&1 \
            && echo "xinput --set-prop $id $accel_prop $accel_speed" \
            && xinput --set-prop "$id" "$accel_prop" "$accel_speed"
    done
done

if [ $(xinput | rg "${mice[0]}") ]; then
    polychromatic-cli --name "${mice[0]} (Wireless)" --dpi 3200
    polychromatic-cli --name "${mice[0]} (Wireless)" --option poll_rate --parameter 1000
fi

if [ "$1" = "--mouse-only" ]; then
    exit 0
fi

killall picom
"$DOT/scripts/liquidctl.sh" 4
sleep 5; notify-send --urgency=critical "gpu-screen-recorder" "Enable GPU screen recorder"
