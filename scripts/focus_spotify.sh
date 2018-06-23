#!/bin/sh

if ! pgrep -x spotify >/dev/null; then
    i3-msg 'exec --no-startup-id spotify'
else
    i3-msg '[class="Spotify"] focus'
fi
