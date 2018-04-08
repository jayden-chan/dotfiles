#!/bin/sh

scrot -s $HOME/scrotTemp.png
xclip -selection clipboard -t image/png -i $HOME/scrotTemp.png
rm $HOME/scrotTemp.png
notify-send Scrot Screenshot\ taken\ \(selection\)
