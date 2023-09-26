#!/bin/zsh

log_file="/home/jayden/.cache/pw-orchestrator-log.log"

# don't bother starting if Carla is already running
pgrep -x carla > /dev/null && exit

sleep 3
echo "[carla.sh] [$(date)] Restarting pipewire + wireplumber" >> ~/.xsession-errors
systemctl --user restart pipewire pipewire-pulse wireplumber

sleep 3
echo "[carla.sh] [$(date)] Starting pw-orchestrator and Carla" >> ~/.xsession-errors
$DOT/misc/pw-orchestrator.ts > /tmp/pw-orchestrator-config.json
rm -f "$log_file"
PW_ORCH_DEBUG=0 PW_ORCH_LOGFILE="$log_file" pw-orchestrator daemon /tmp/pw-orchestrator-config.json &

if ! pgrep -x gpu-screen-reco &> /dev/null 2>&1 ; then
    echo "[carla.sh] [$(date)] Starting gpu-screen-recorder" >> ~/.xsession-errors
    gpu-screen-recorder \
        -w DP-2 \
        -c mp4 \
        -f 60 \
        -q very_high \
        -r 240 \
        -a audio-device-sink.monitor \
        -a carla-source \
        -ac opus \
        -k h265 \
        -v no \
        -o ~/Videos/replays 2>&1 | ts '%s' > /tmp/gpu-screen-recorder.log &
fi

sleep 1
~/Dev/Testing/Carla/source/frontend/carla ~/Documents/Default.carxp
echo "[carla.sh] [$(date)] Carla exiting, killing pw-orchestrator instances" >> ~/.xsession-errors
ps -ax | rg "^\s*(\d+).*\d node.*pw-orchestrator" --only-matching --replace='$1' | xargs kill
killall gpu-screen-recorder
