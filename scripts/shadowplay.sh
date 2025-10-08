#!/usr/bin/env bash

if [ "$1" = "record" ]; then
    if [ "$2" = "" ]; then
        echo "Specify the output file name"
        echo "./shadowplay.sh record ~/path/to/output.mp4"
        exit 1
    fi

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
        -q high \
        -v no \
        -w DP-0 \
        -o "$2" 2>&1
else
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
fi
