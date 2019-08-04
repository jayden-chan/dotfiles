#!/bin/sh

maim -B -s -o | xclip -selection clipboard -t image/png
notify-send "Maim" "Screenshot taken"
