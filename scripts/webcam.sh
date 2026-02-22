#!/usr/bin/env bash

logged_cmd() {
    local rc=0
    set -x
    "$@"
    { { rc=$?; set +x; }; } 2>/dev/null
    return "$rc"
}

webcam_model="C920"

video_device=$(v4l2-ctl --list-devices | rg "C920" -A 1 | tail -n +2 | awk '{$1=$1};1')
audio_device=$(pw-cli list-objects Node | rg "$webcam_model" | rg 'node\.name = "(.*)"' --only-matching --replace='$1' --color=never)

echo "Video Device: $video_device"
echo "Audio Device: $audio_device"
echo

if [ "$1" = "focus" ]; then
    logged_cmd v4l2-ctl -d "$video_device" -c focus_absolute="$2"
    exit $?
fi

if [ "$1" = "exposure" ]; then
    logged_cmd v4l2-ctl -d "$video_device" -c exposure_time_absolute="$2"
    exit $?
fi

echo "Setting camera to 1080p"
logged_cmd v4l2-ctl -d "$video_device" --set-fmt-video=width=1920,height=1080,pixelformat=MJPG --set-parm=30

sleep 1

echo "Configuring optional camera settings"

# auto_exposure=1 means Manual Mode
# auto_exposure=3 means Aperture Priority Mode
logged_cmd v4l2-ctl -d "$video_device" -c auto_exposure=1
sleep 1
logged_cmd v4l2-ctl -d "$video_device" -c gain=50
sleep 1
logged_cmd v4l2-ctl -d "$video_device" -c exposure_dynamic_framerate=0
sleep 1
logged_cmd v4l2-ctl -d "$video_device" -c focus_automatic_continuous=0
sleep 3
logged_cmd v4l2-ctl -d "$video_device" -c focus_absolute=40
sleep 1
logged_cmd v4l2-ctl -d "$video_device" -c exposure_time_absolute=156

echo "Starting feed"
ffmpeg -f v4l2 -input_format mjpeg \
    -video_size 1920x1080 -framerate 30 \
    -i "$video_device" \
    -f pulse -i "$audio_device" \
    -fflags nobuffer -flags low_delay \
    -vf "crop=1440:1080:240:0" \
    -c:v h264_nvenc -preset p3 -tune ll \
    -loglevel fatal \
    -f mpegts - \
    | mpv \
    --profile=fast \
    --msg-level=all=no \
    --untimed \
    --no-cache \
    -
