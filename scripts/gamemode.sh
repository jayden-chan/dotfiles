#!/usr/bin/env bash

for id in $(xinput | rg "Razer Razer Viper V3 Pro" | rg "pointer" | rg "id=(\d+)" --color=never --only-matching --replace='$1'); do
    xinput --set-prop "$id" 'libinput Accel Speed' -0.55
done

for id in $(xinput | rg "Razer Razer Viper V2 Pro" | rg "pointer" | rg "id=(\d+)" --color=never --only-matching --replace='$1'); do
    xinput --set-prop "$id" 'libinput Accel Speed' -0.55
done

polychromatic-cli --name "Razer Viper V2 Pro (Wireless)" --dpi 1600
polychromatic-cli --name "Razer Viper V2 Pro (Wireless)" --option poll_rate --parameter 1000
polychromatic-cli --name "Razer Viper V3 Pro (Wireless)" --dpi 1600
polychromatic-cli --name "Razer Viper V3 Pro (Wireless)" --option poll_rate --parameter 1000

if [ "$1" = "--mouse-only" ]; then
    exit 0
fi

killall picom
"$DOT/scripts/liquidctl.sh" 4
