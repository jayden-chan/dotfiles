#!/usr/bin/env bash

tmp_file=$(mktemp -t xcolor-XXXXXX.png)
color=$(xcolor | tr -d '\n' | xclip -selection c -filter)
convert -size 75x75 "xc:$color" "$tmp_file"
notify-send -i "$tmp_file" -t 3000 "Color picker" "$color"
rm "$tmp_file"

if [ "$1" = "--theme-pick" ]; then
    sed -i -E "s|export ([A-Z]{6})_COLOR=\"#\w{6}\"|export \1_COLOR=\"$color\"|g" ~/.config/ENV
fi
