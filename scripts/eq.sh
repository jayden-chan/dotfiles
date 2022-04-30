#!/usr/bin/dash

existing_pid=$(ps -ax | rg "(\d+) (?:.*) pipewire -c /home/jayden/\.config/dotfiles/pipewire/(.*)\.conf" --only-matching --replace='$1')

if [ "$existing_pid" != "" ]; then
    existing_name=$(ps -ax | rg "(\d+) (?:.*) pipewire -c /home/jayden/\.config/dotfiles/pipewire/(.*)\.conf" --only-matching --replace='$2')
    echo "Stopping existing EQ: $existing_name"
    kill "$existing_pid"
    sleep 0.2
fi

echo "Starting EQ $1"
pipewire -c ~/.config/dotfiles/pipewire/"$1".conf &
sleep 0.2
pactl set-default-sink "effect_input.eq"

hostname=$(hostname)

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
