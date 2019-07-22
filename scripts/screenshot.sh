#!/bin/sh

maim -s -o | xclip -selection clipboard -t image/png
notify-send Scrot Screenshot\ taken\ \(selection\)
