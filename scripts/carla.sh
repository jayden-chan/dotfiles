#!/usr/bin/env bash

exec >/home/jayden/.cache/carla-sh-logs.log 2>&1

# don't bother starting if Carla is already running
pgrep -x carla > /dev/null && exit

sleep 3
echo "[carla.sh] [$(date)] Restarting pipewire + wireplumber"
systemctl --user restart pipewire pipewire-pulse wireplumber

sleep 3
echo "[carla.sh] [$(date)] Starting pw-orchestrator and Carla"
$DOT/misc/pw-orchestrator.ts > /tmp/pw-orchestrator-config.json
pw-orchestrator daemon /tmp/pw-orchestrator-config.json &

sleep 3
~/Dev/Testing/Carla/source/frontend/carla ~/Documents/Default.carxp
echo "[carla.sh] [$(date)] Carla exiting, killing pw-orchestrator instances"
ps -ax | rg "^\s*(\d+).*\d node.*pw-orchestrator" --only-matching --replace='$1' | xargs kill
killall gpu-screen-recorder
killall amidi
