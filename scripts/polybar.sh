#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

if [ "$(hostname)" = "swift" ]; then
    echo "---" | tee -a /tmp/polybar1.log
    polybar center 2>&1 | tee -a /tmp/polybar1.log & disown
else
    echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log /tmp/polybar3.log
    MONITOR=HDMI-0  polybar base   2>&1 | tee -a /tmp/polybar1.log & disown
    MONITOR=DP-0    polybar center 2>&1 | tee -a /tmp/polybar2.log & disown
    MONITOR=DVI-D-0 polybar base   2>&1 | tee -a /tmp/polybar3.log & disown
fi
