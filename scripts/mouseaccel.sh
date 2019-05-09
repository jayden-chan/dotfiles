#!/bin/sh

if [ $(hostname) = "grace" ]; then
    for id in `xinput --list | rg 'Logitech Gaming Mouse G502\s+id=(\d+)\s+\[slave\s+pointer' --only-matching --replace='$1'`; do
        xinput --set-prop $id 'Coordinate Transformation Matrix' 3.8 0.0 0.0 0.0 3.8 0.0 0.0 0.0 1.0
        xinput --set-prop $id 'libinput Accel Speed' -1
    done
else
    xinput --set-prop 'SYNA2B2C:01 06CB:7F27 Touchpad' 'libinput Natural Scrolling Enabled' 0
    xinput --set-prop 'SYNA2B2C:01 06CB:7F27 Touchpad' 'libinput Tapping Enabled' 1

    for id in `xinput --list | rg 'Logitech MX Master 2S\s+id=(\d+)\s+\[slave\s+pointer' --only-matching --replace='$1'`; do
        xinput --set-prop $id 'Coordinate Transformation Matrix' 1.6 0.0 0.0 0.0 1.6 0.0 0.0 0.0 1.0
        xinput --set-prop $id 'libinput Accel Speed' -1
    done
fi
