#!/bin/sh

vol=$(amixer sget Master | grep -o -P '\[\d+' | sed 's/^\[//g')

notify-send -h "int:value:$vol" Sound Volume:
