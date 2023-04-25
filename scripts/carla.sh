#!/bin/zsh

# don't bother starting if Carla is already running
pgrep -x carla > /dev/null && exit

echo "[carla.sh] [$(date)] Starting pw-orchestrator and Carla" >> ~/.xsession-errors
$DOT/misc/pw-orchestrator.ts > /tmp/pw-orchestrator-config.json
pw-orchestrator daemon /tmp/pw-orchestrator-config.json &
sleep 1
~/Dev/Testing/Carla/source/frontend/carla ~/Documents/Default.carxp
echo "[carla.sh] [$(date)] Carla exiting, killing pw-orchestrator instances" >> ~/.xsession-errors
ps -ax | rg "^\s*(\d+).*\d node.*pw-orchestrator" --only-matching --replace='$1' | xargs kill
