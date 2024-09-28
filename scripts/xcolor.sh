#!/usr/bin/env bash

tmp_file=$(mktemp -t xcolor-XXXXXX.png)
color=$(xcolor | tr -d '\n' | xclip -selection c -filter)
convert -size 75x75 "xc:$color" "$tmp_file"
notify-send -i "$tmp_file" -t 3000 "Color picker" "$color"
rm "$tmp_file"
