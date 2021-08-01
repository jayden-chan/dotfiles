#!/usr/bin/dash

# Author:   Nicholas Feldman, Jayden Chan
# Based on: https://github.com/NicholasFeldman/dotfiles/blob/master/polybar/.config/polybar/spotify.sh

max_chars=150

main() {
    if ! pgrep -x spotify >/dev/null; then
        echo ""; exit
    fi

    cmd="org.freedesktop.DBus.Properties.Get"
    domain="org.mpris.MediaPlayer2"
    path="/org/mpris/MediaPlayer2"

    meta=$(dbus-send --print-reply --dest=${domain}.spotify \
        /org/mpris/MediaPlayer2 $cmd string:${domain}.Player string:Metadata)

    artist=$(echo "$meta" | sed -nr '/xesam:artist"/,+2s/^ +string "(.*)"$/\1/p' | tail -1)
    album=$(echo "$meta" | sed -nr '/xesam:album"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1)
    title=$(echo "$meta" | sed -nr '/xesam:title"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1)

    status=$(dbus-send --print-reply --dest=$domain.spotify $path $cmd string:$domain.Player string:PlaybackStatus | grep Playing)

    if [ "$status" = "" ]; then
        echo Paused
    elif [ $((${#title}+${#artist})) -gt $max_chars ]; then
        echo $(echo $artist - $title | cut -c -$max_chars)...
    else
        echo $artist - $title
    fi
}

main "$@"
