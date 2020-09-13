#!/bin/sh

if [ $(hostname) = "grace" ]; then
    cspeed=1.5
    xinput --set-prop 'Cooler Master Technology Inc. MM710 Gaming Mouse' 'Coordinate Transformation Matrix' $cspeed 0.0 0.0 0.0 $cspeed 0.0 0.0 0.0 1.0
    xinput --set-prop 'Cooler Master Technology Inc. MM710 Gaming Mouse' 'libinput Accel Speed' -1
else
    xinput --set-prop 'SYNA2B2C:01 06CB:7F27 Touchpad' 'libinput Natural Scrolling Enabled' 0
    xinput --set-prop 'SYNA2B2C:01 06CB:7F27 Touchpad' 'libinput Tapping Enabled' 1

    hspeed=1.8
    xinput --set-prop 'HP HP Link-5 micro dongle Mouse' 'Coordinate Transformation Matrix' $hspeed 0.0 0.0 0.0 $hspeed 0.0 0.0 0.0 1.0
    xinput --set-prop 'HP HP Link-5 micro dongle Mouse' 'libinput Accel Speed' -1
fi
