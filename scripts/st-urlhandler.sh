#!/bin/dash

# Based on:
# https://github.com/LukeSmithxyz/st/blob/0af4782a47cc1b0918bdc41fb61b1a5d358f75f6/st-urlhandler

urlregex='((http|https|git|ftp|ftps|ssh)://((?:\w+(?:(?:\.|@)\w+)+)|(localhost)|(\d+\.\d+\.\d+\.\d+))(:\d+)?[-.=&?_a-zA-Z0-9/]+)'
pathregex='((\s|^)~(/(\w|\d|-|_)+)+(\.(\w|\d)+)?)'

# make the script work across multiple lines and
# perform a /home/<user> -> ~ conversion
input=$(tr -d '\n' | sed "s|$HOME|~|g")

while getopts "oc" o; do case "${o}" in
    o)
        matches=$(echo "$input" | rg --only-matching -N $urlregex | sort | uniq)
        [ -z "$matches" ] && exit 1
        chosen="$(echo "$matches" | rofi -dmenu -i -p "follow url:" -theme links)"
        setsid xdg-open "$chosen" >/dev/null 2>&1 & ;;
    c)
        matches=$(echo "$input" | rg --only-matching -N "$urlregex|$pathregex" | sort | uniq)
        [ -z "$matches" ] && exit 1
        echo "$matches" | rofi -dmenu -i -p "copy url:" -theme links | tr -d '\n' | xclip -selection clipboard ;;
    *) printf "Invalid option: -%s\\n" "$OPTARG" && exit 1 ;;
esac done
