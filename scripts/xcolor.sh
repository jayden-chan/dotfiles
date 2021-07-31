#!/bin/sh

tmp_dir=$(mktemp -d -t xcolor-XXXXXX)
color=$(xcolor | tr -d '\n' | xclip -selection c -filter)
convert -size 75x75 xc:$color $tmp_dir/icon.png
notify-send -i $tmp_dir/icon.png -t 3000 "Color picker" $color
rm -rf $tmp_dir
