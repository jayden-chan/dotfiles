#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u jayden -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
polybar $(hostname) &

echo "Bars launched..."
