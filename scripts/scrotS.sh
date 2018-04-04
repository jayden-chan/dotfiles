#!/bin/sh

scrot -s ~/scrotTemp.png
xclip -selection clipboard -t image/png -i ~/scrotTemp.png
rm ~/scrotTemp.png
notify-send Scrot Screenshot\ taken\ \(selection\)
