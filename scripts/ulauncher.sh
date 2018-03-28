#!/usr/bin/env sh

# Terminate already running instances
killall -q ulauncher

# Wait for running instances to shut down
while pgrep -u jayden -x ulauncher >/dev/null; do sleep 1; done

# Wait until compton starts
while ! pgrep -u jayden -x compton >/dev/null; do sleep 1; done

# Launch Ulauncher
ulauncher &

echo "Ulauncher launched..."
