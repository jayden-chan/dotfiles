#!/bin/zsh

horn=""
skin=""
if [[ "${1:t:e}" == "ogg" ]]; then
    horn="$1"
    skin="$2"
else
    horn="$2"
    skin="$1"
fi

new_skin="${skin:r}_${horn:t:r}.zip"
work_dir=/tmp/__horn__temp/workdir

mkdir -p "$work_dir"
cd "$work_dir"
unzip "$skin"
ffmpeg -i "$horn" -ac 1 ./horn.ogg
zip "$new_skin" ./*
cd /tmp
rm -rf "$work_dir"
