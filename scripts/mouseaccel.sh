#!/bin/sh

if [ $(hostname) == "grace" ]; then
    for id in `xinput --list | grep 'pointer' | grep 'Logitech Gaming Mouse G502' | grep -o -P 'id=\d+' | grep -o -P '\d+'`; do
        xinput --set-prop $id 'Coordinate Transformation Matrix' 3.8 0.0 0.0 0.0 3.8 0.0 0.0 0.0 1.0
        xinput --set-prop $id 'libinput Accel Speed' -1
    done
else
    xinput --set-prop 'SYNA2B2C:01 06CB:7F27 Touchpad' 'libinput Natural Scrolling Enabled' 0

    xinput --set-prop 'Logitech USB Optical Mouse' 'Coordinate Transformation Matrix' 1.8 0.0 0.0 0.0 1.8 0.0 0.0 0.0 1.0
    xinput --set-prop 'Logitech USB Optical Mouse' 'libinput Accel Speed' -1
fi
