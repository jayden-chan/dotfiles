#!/bin/zsh

chosen_wall=$(fd . ${1:-.} -e png -e jpg -e jpeg -e webp | sxiv - -t -b -o -g 1600x900)
if [ "$chosen_wall" = "" ]; then
    echo "no image chosen"
else
    nitrogen --set-zoom-fill --save "$chosen_wall" --head=0 2>/dev/null
    nitrogen --set-zoom-fill --save "$chosen_wall" --head=1 2>/dev/null
    nitrogen --set-zoom-fill --save "$chosen_wall" --head=2 2>/dev/null
    cp "$chosen_wall" /usr/share/backgrounds/wall
    chmod 777 /usr/share/backgrounds/wall
fi
