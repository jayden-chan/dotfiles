#!/bin/sh

gspeed=3.8
for id in `xinput --list | rg 'Logitech Gaming Mouse G502\s+id=(\d+)\s+\[slave\s+pointer' --only-matching --replace='$1'`; do
    xinput --set-prop $id 'Coordinate Transformation Matrix' $gspeed 0.0 0.0 0.0 $gspeed 0.0 0.0 0.0 1.0
    xinput --set-prop $id 'libinput Accel Speed' -1
done


if [ $(hostname) = "grace" ]; then
    cspeed=1.5
    xinput --set-prop 'Glorious Model O' 'Coordinate Transformation Matrix' $cspeed 0.0 0.0 0.0 $cspeed 0.0 0.0 0.0 1.0
    xinput --set-prop 'Glorious Model O' 'libinput Accel Speed' -1
    xinput --set-prop 'Glorious Model D' 'Coordinate Transformation Matrix' $cspeed 0.0 0.0 0.0 $cspeed 0.0 0.0 0.0 1.0
    xinput --set-prop 'Glorious Model D' 'libinput Accel Speed' -1
else
    xinput --set-prop 'SYNA2B2C:01 06CB:7F27 Touchpad' 'libinput Natural Scrolling Enabled' 0
    xinput --set-prop 'SYNA2B2C:01 06CB:7F27 Touchpad' 'libinput Tapping Enabled' 1

    hspeed=1.8
    xinput --set-prop 'HP HP Link-5 micro dongle Mouse' 'Coordinate Transformation Matrix' $hspeed 0.0 0.0 0.0 $hspeed 0.0 0.0 0.0 1.0
    xinput --set-prop 'HP HP Link-5 micro dongle Mouse' 'libinput Accel Speed' -1

    zspeed=1.5
    xinput --set-prop 'Kingsis Peripherals ZOWIE Gaming mouse' 'Coordinate Transformation Matrix' $zspeed 0.0 0.0 0.0 $zspeed 0.0 0.0 0.0 1.0
    xinput --set-prop 'Kingsis Peripherals ZOWIE Gaming mouse' 'libinput Accel Speed' -1
fi
