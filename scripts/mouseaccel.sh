#!bin/sh

for id in `xinput --list | grep 'pointer' | grep 'Logitech Gaming Mouse G502' | grep -o -P 'id=\d+' | grep -o -P '\d+'`; do
    xinput --set-prop $id 153 3.8 0.0 0.0 0.0 3.8 0.0 0.0 0.0 1.0
done

xinput --set-prop 'SYNA2B2C:01 06CB:7F27 Touchpad' 296 -0.2

notify-send xinput 'Mouse sensitivity set'
