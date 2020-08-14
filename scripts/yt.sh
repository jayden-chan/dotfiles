#!/bin/bash

set -e

historyfile="$HOME/.youtube-history.ndjson"

url=""
if [ -z "$1" ]; then
	url=$(xclip -out -selection clipboard)
else
	url=$1
fi

echo "Fetching streaming information..."
x=$(youtube-dl --no-playlist --format 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best[height<=1080]' -g -e $url --dump-json)
readarray -t y <<<"$x"

# y[0] - title
# y[1] - video URL
# y[2] - audio URL
# y[3] - JSON info

echo "${y[3]}" | jq -c "{script: true, title: (\"Watched \" + .title), titleUrl: (\"https://www.youtube.com/watch?v=\" + .id), subtitles: {name: .uploader, url: .channel_url}, time: \"$(date --utc +'%Y-%m-%dT%H:%M:%S.%3NZ')\"}" >> $historyfile

echo "Opening stream in vlc..."
echo "${y[3]}" | jq -r '"Quality: " + (.requested_formats[0].height|tostring) + "p " + (.requested_formats[0].fps|tostring) + "fps " + (.requested_formats[0].vcodec|tostring) + " " + (.requested_formats[1].acodec|tostring)'
vlc "${y[1]}" --input-slave "${y[2]}" --audio --meta-title="${y[0]}" --fullscreen --play-and-exit 2>/dev/null
