#!/bin/dash

# Based on:
# https://github.com/LukeSmithxyz/st/blob/0af4782a47cc1b0918bdc41fb61b1a5d358f75f6/st-urlhandler

urlregex='(https?|git|ftp|ftps)://(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'
input=$(cat -)
urls=$(echo $input | tr -d '\n' | rg --no-binary --only-matching -N $urlregex | sort | uniq)

[ -z "$urls" ] && exit 1

while getopts "oc" o; do case "${o}" in
    o) chosen="$(echo "$urls" | rofi -dmenu -i -p "follow url:" -theme links)"
    setsid xdg-open "$chosen" >/dev/null 2>&1 & ;;
    c) echo "$urls" | rofi -dmenu -i -p "copy url:" -theme links | tr -d '\n' | xclip -selection clipboard ;;
    *) printf "Invalid option: -%s\\n" "$OPTARG" && exit 1 ;;
esac done
