#!/usr/bin/dash

prev="None"
prev_file="$HOME/.local/state/eq.txt"
if [ -f "$prev_file" ]; then
    prev=$(cat "$prev_file" | tr -d '\n')
fi

eq=${1:-$prev}

existing_pid=$(ps -ax | rg "(\d+) (?:.*) pipewire -c /home/jayden/\.config/dotfiles/pipewire/(.*)\.conf" --only-matching --replace='$1')

if [ "$existing_pid" != "" ]; then
    existing_name=$(ps -ax | rg "(\d+) (?:.*) pipewire -c /home/jayden/\.config/dotfiles/pipewire/(.*)\.conf" --only-matching --replace='$2')
    echo "Stopping existing EQ: $existing_name"
    kill "$existing_pid"
    sleep 0.2
fi

echo "Starting EQ $eq"
pipewire -c ~/.config/dotfiles/pipewire/"$eq".conf &
sleep 0.2
pactl set-default-sink "effect_input.eq"
echo "$eq" > $prev_file

# hostname=$(hostname)

# if [ "$hostname" = "grace" ]; then
#     echo "Linking EQ -> FiiO E10 USB DAC"
#     pw-link effect_output.eq:output_FL alsa_output.usb-FiiO_DigiHug_USB_Audio-01.analog-stereo:playback_FL
#     pw-link effect_output.eq:output_FR alsa_output.usb-FiiO_DigiHug_USB_Audio-01.analog-stereo:playback_FR
# fi

# if [ "$hostname" = "swift" ]; then
#     # TODO
#     # pw-link effect_output.eq:output_FL alsa_output.usb-FiiO_DigiHug_USB_Audio-01.analog-stereo:playback_FL
#     # pw-link effect_output.eq:output_FR alsa_output.usb-FiiO_DigiHug_USB_Audio-01.analog-stereo:playback_FR
# fi
