#!/usr/bin/dash

if [ "$1" = "--at2040" ]; then

    existing_pid=$(ps -ax | rg "(\d+) (?:.*) pipewire -c (?:.*)/dotfiles/afx/pipewire/source-([a-zA-Z0-9_]+)\.conf" --only-matching --replace='$1')

    if [ "$existing_pid" != "" ]; then
        existing_name=$(ps -ax | rg "(\d+) (?:.*) pipewire -c (?:.*)/dotfiles/afx/pipewire/source-([a-zA-Z0-9_]+)\.conf" --only-matching --replace='$2')
        echo "Stopping existing EQ: $existing_name"
        kill "$existing_pid"
        sleep 0.2
    fi

    pipewire -c ~/.config/dotfiles/afx/pipewire/source-AT2040.conf &
    # give the pipewire process higher priority
    renice -n -11 -p $!

    sleep 0.5
    pactl set-default-source effect_output.at2040
    sleep 0.2

    pw-link -d alsa_input.usb-Focusrite_Scarlett_Solo_USB_Y7E3FPF1B27EC5-00.analog-stereo:capture_FL effect_input.at2040:input_FL
    pw-link -d alsa_input.usb-Focusrite_Scarlett_Solo_USB_Y7E3FPF1B27EC5-00.analog-stereo:capture_FR effect_input.at2040:input_FR

    # capture_FL is the mono output of the left side input on the Scarlett -- capture_FR is the mono output of the second input
    pw-link alsa_input.usb-Focusrite_Scarlett_Solo_USB_Y7E3FPF1B27EC5-00.analog-stereo:capture_FL effect_input.at2040:input_FL
    pw-link alsa_input.usb-Focusrite_Scarlett_Solo_USB_Y7E3FPF1B27EC5-00.analog-stereo:capture_FL effect_input.at2040:input_FR

    if [ "$2" = "--listen" ]; then
        pw-link effect_output.at2040:capture_MONO effect_input.eq:playback_FL
        pw-link effect_output.at2040:capture_MONO effect_input.eq:playback_FR
    fi

    exit
fi

prev="None"
prev_file="$HOME/.local/state/eq.txt"
if [ -f "$prev_file" ]; then
    prev=$(< "$prev_file" tr -d '\n')
fi

eq=${1:-$prev}

existing_pid=$(ps -ax | rg "(\d+) (?:.*) pipewire -c (?:.*)/dotfiles/afx/pipewire/sink-([a-zA-Z0-9_]+)\.conf" --only-matching --replace='$1')

if [ "$existing_pid" != "" ]; then
    existing_name=$(ps -ax | rg "(\d+) (?:.*) pipewire -c (?:.*)/dotfiles/afx/pipewire/sink-([a-zA-Z0-9_]+)\.conf" --only-matching --replace='$2')
    echo "Stopping existing EQ: $existing_name"
    kill "$existing_pid"
    sleep 0.2
fi

echo "Starting EQ $eq"

pipewire -c ~/.config/dotfiles/afx/pipewire/sink-"$eq".conf &
# give the pipewire process higher priority
renice -n -11 -p $!

sleep 0.5
pactl set-default-sink effect_input.eq

echo "$eq" > "$prev_file"
