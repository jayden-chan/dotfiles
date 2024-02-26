#!/bin/bash

if [ "$1" = "bathys_eq" ]; then
    printf '90 03 7F\n80 03 7F' | nc -N -U /tmp/pipewire-orchestrator.sock
fi

if [ "$1" = "hexa_eq" ]; then
    printf '90 07 7F\n80 07 7F' | nc -N -U /tmp/pipewire-orchestrator.sock
fi

if [ "$1" = "disable_eq" ]; then
    printf '90 07 7F\n80 07 7F' | nc -i 1 -N -U /tmp/pipewire-orchestrator.sock
fi

if [ "$1" = "mic_mute" ]; then
    printf '90 44 7F\n80 44 7F' | nc -N -U /tmp/pipewire-orchestrator.sock
fi

if [ "$1" = "cooler_control" ]; then
    printf '90 52 7F\n80 52 7F' | nc -N -U /tmp/pipewire-orchestrator.sock
fi

if [ "$1" = "clip_save" ]; then
    printf '90 5D 7F\n80 5D 7F' | nc -N -U /tmp/pipewire-orchestrator.sock
fi
