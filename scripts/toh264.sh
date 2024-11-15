#!/usr/bin/env zsh
notify-send "ffmpeg conversion started"
ffmpeg -hide_banner -i "$1" -c:v libx264 -c:a copy "${1:r}_h264.mp4"
notify-send "ffmpeg conversion finished"
