#!/bin/zsh

xset r rate 300 35 # Set key repeat delay and rate
xmodmap -e "clear lock"                   # Disable caps lock switch
xmodmap -e "keysym Caps_Lock = Escape"    # Set caps lock as escape
xmodmap -e "keycode 9 = grave asciitilde" # Set escape as grave/tilde (anne pro)
