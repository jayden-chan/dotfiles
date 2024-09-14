#!/usr/bin/env zsh

# -t     Start in thumbnail mode.
# -b     Do not show info bar on bottom of window.
# -o     Write list of all marked files to standard output when quitting.
# -g     <GEOMETRY> Set window position and size.
chosen_wall=$(fd . ${1:-.} -e png -e jpg -e jpeg -e webp | nsxiv - -t -b -o -g 1600x900)

if [ "$chosen_wall" = "" ]; then
    echo "no image chosen"
else
    nitrogen --set-zoom-fill --save "$chosen_wall" --head=0 2>/dev/null
    nitrogen --set-zoom-fill --save "$chosen_wall" --head=1 2>/dev/null
    cp "$chosen_wall" $DOT/nix/common/wall
fi
