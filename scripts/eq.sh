#!/usr/bin/dash

prev="None"
prev_file="$HOME/.local/state/eq.txt"
if [ -f "$prev_file" ]; then
    prev=$(< "$prev_file" tr -d '\n')
fi

eq=${1:-$prev}

existing_pid=$(ps -ax | rg "(\d+) (?:.*) pipewire -c /home/jayden/\.config/dotfiles/pipewire/sink-(.*)\.conf" --only-matching --replace='$1')

if [ "$existing_pid" != "" ]; then
    existing_name=$(ps -ax | rg "(\d+) (?:.*) pipewire -c /home/jayden/\.config/dotfiles/pipewire/sink-(.*)\.conf" --only-matching --replace='$2')
    echo "Stopping existing EQ: $existing_name"
    kill "$existing_pid"
    sleep 0.2
fi

echo "Starting EQ $eq"
pipewire -c ~/.config/dotfiles/pipewire/sink-"$eq".conf &
sleep 0.5
pactl set-default-sink "effect_input.eq"
echo "$eq" > "$prev_file"
