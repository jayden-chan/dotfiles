#!/bin/sh

if [ $1 = "--single" ]; then
    i3-msg "layout splitv; gaps inner current set 0; gaps outer current set 46 append_layout /home/jayden/Documents/Git/dotfiles/i3/ide1.json; exec --no-startup-id alacritty"
    sleep 0.25
    i3-msg "focus down; exec --no-startup-id alacritty"
elif [ $1 = "--double" ]; then
    i3-msg "layout splitv; gaps inner current set 0; gaps outer current set 46 append_layout /home/jayden/Documents/Git/dotfiles/i3/ide2.json; exec --no-startup-id alacritty"
    sleep 0.25
    i3-msg "focus down; exec --no-startup-id alacritty"
    sleep 0.25
    i3-msg "focus right; exec --no-startup-id alacritty"
fi
