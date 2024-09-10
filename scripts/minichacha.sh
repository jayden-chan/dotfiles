#!/usr/bin/env bash

mode="$1"
file="$2"
extra_arg="$3"

notify () {
    echo "$1"
    notify-send "minichacha.sh" "$1"
}

if [ "$file" = "" ]; then
    msg="Error: must provide input file"
    notify "$msg"
    exit 1
fi

if [ "$mode" = "encrypt" ]; then
    passphrase="$(zenity --password)"
    passphrase2="$(zenity --password)"

    if [ "$passphrase" != "$passphrase2" ]; then
        notify "Error: passphrases don't match"
        exit 1
    fi

    minichacha encrypt "$file" --passphrase "$passphrase"

    if [ "$extra_arg" = "--shred" ]; then
        shred -u "$file"
    fi

    notify "File encrypted"
    exit 0
fi

if [ "$mode" = "decrypt" ]; then
    passphrase="$(zenity --password)"
    if [ "$extra_arg" = "--write" ]; then
        minichacha decrypt "$file" --passphrase "$passphrase"
        notify "File decrypted"
    else
        minichacha decrypt "$file" --passphrase "$passphrase" --output /dev/stdout | xclip -selection c
        notify "File decrypted and copied to clipboard"
    fi
    exit 0
fi

notify "Unknown mode \"$mode\""
