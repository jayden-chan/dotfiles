#!/usr/bin/env bash

alias maimselect='maim --noopengl --capturebackground --select --hidecursor'
alias clip='xclip -selection c -filter'

tmp_file=$(mktemp -t maimscript-XXXXXX)

case "$1" in
    # select a region to screenshot (or click to screenshot window)
    --select)
        maimselect | clip -t image/png > "$tmp_file"
        notify-send -i "$tmp_file" "Maim" "Screenshot taken"
        ;;
    # scan a QR code
    --qr)
        maimselect > "$tmp_file"
        scanresult=$(zbarimg --quiet --raw "$tmp_file" | tr -d '\n')

        if [ -z "$scanresult" ]; then
            notify-send "Maim" "No scan data found"
        else
            echo "$scanresult" | clip
            notify-send -i "$tmp_file" "Maim" "$scanresult\n(copied to clipboard)"
        fi

        rm "$tmp_file"
        ;;
    # screenshot the entire desktop
    *)
        maim --noopengl | clip -t image/png > "$tmp_file"
        notify-send -i "$tmp_file" "Maim" "Screenshot taken"
        ;;
esac

rm -f "$tmp_file"
