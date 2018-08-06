#!/usr/bin/zsh

i3-msg "workspace 4; layout splitv; gaps inner current set 0; gaps outer current set 46 append_layout /home/jayden/Documents/Git/dotfiles/i3/ide_layout.json; exec --no-startup-id termite"

sleep 0.25

i3-msg "focus down; exec --no-startup-id termite; focus up"

