#!/usr/bin/env sh

# Terminate already running instances
killall -q ulauncher

# Wait until the processes have been shut down
while pgrep -u $UID -x ulauncher >/dev/null; do sleep 1; done

# Launch Ulauncher
ulauncher &

echo "Ulauncher launched..."
