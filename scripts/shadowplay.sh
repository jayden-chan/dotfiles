#!/usr/bin/env bash
gpu-screen-recorder \
    -a audio-device-sink.monitor \
    -a carla-source \
    -ab 256 \
    -ac opus \
    -bm qp \
    -c mp4 \
    -cr limited \
    -cursor yes \
    -encoder gpu \
    -f 60 \
    -fm vfr \
    -k av1 \
    -q ultra \
    -r 200 \
    -v yes \
    -w DP-0 \
    -o ~/Videos/replays 2>&1
