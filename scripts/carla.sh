#!/bin/bash

exec >/home/jayden/.cache/carla-sh-logs.log 2>&1

# don't bother starting if Carla is already running
pgrep -x carla > /dev/null && exit

sleep 2
echo "[carla.sh] [$(date)] Restarting pipewire + wireplumber"
systemctl --user restart pipewire pipewire-pulse wireplumber

sleep 2
echo "[carla.sh] [$(date)] Starting pw-orchestrator and Carla"
$DOT/misc/pw-orchestrator.ts > /tmp/pw-orchestrator-config.json
PW_ORCH_DEBUG=1 pw-orchestrator daemon /tmp/pw-orchestrator-config.json &

sleep 2
~/Dev/Testing/Carla/source/frontend/carla ~/Documents/Default.carxp
echo "[carla.sh] [$(date)] Carla exiting, killing pw-orchestrator instances"
ps -ax | rg "^\s*(\d+).*\d node.*pw-orchestrator" --only-matching --replace='$1' | xargs kill
killall gpu-screen-recorder
