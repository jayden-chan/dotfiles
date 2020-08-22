#!/bin/bash

set -e

url=""
if [ -z "$1" ]; then
	url=$(xclip -out -selection clipboard)
else
	url="https://twitch.tv/$1"
fi

streamlink --player "vlc --fullscreen --play-and-exit" $url best
