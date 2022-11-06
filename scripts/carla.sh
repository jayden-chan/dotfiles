#!/bin/zsh

# don't bother starting if Carla is already running
pgrep -x carla > /dev/null && exit

pw-orchestrator daemon =($DOT/misc/pw-orchestrator.js) &
sleep 1
~/Dev/Testing/Carla/source/frontend/carla ~/Documents/Default.carxp
