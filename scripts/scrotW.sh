#!/bin/sh

scrot -u ~/scrotTemp.png
xclip -selection clipboard -t image/png -i ~/scrotTemp.png
rm ~/scrotTemp.png
