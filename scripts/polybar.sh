#!/bin/bash
# bash is necessary for disowning the processes

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

config_path=$HOME/.config/dotfiles/misc/polybar

if [ "$(hostname)" = "swift" ]; then
    echo "---" | tee -a /tmp/polybar1.log
    MONITOR=eDP-1 polybar --config="$config_path" laptop 2>&1 | tee -a /tmp/polybar1.log & disown
else
    monitors=($(polybar -M | cut -d ':' -f 1))
    if [[ "${#monitors[@]}" = "1" ]]; then
        echo "---" | tee -a /tmp/polybar1.log
        MONITOR="${monitors[0]}" polybar --config="$config_path" center 2>&1 | tee -a /tmp/polybar1.log & disown
    else
        echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log /tmp/polybar3.log
        MONITOR=HDMI-0  polybar --config="$config_path" left   2>&1 | tee -a /tmp/polybar1.log & disown
        MONITOR=DP-0    polybar --config="$config_path" center 2>&1 | tee -a /tmp/polybar2.log & disown
        MONITOR=DVI-D-0 polybar --config="$config_path" right  2>&1 | tee -a /tmp/polybar3.log & disown
    fi
fi
