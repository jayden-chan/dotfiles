#!/usr/bin/dash

# Based on:
# https://github.com/LukeSmithxyz/st/blob/0af4782a47cc1b0918bdc41fb61b1a5d358f75f6/st-urlhandler

urlregex="(((http|https|gopher|gemini|ftp|ftps|git)://|www\\.)[a-zA-Z0-9.]*[:]?[a-zA-Z0-9./@$&%?$\#=_~-]*)|((magnet:\\?xt=urn:btih:)[a-zA-Z0-9]*)"

urls="$(sed 's/.*│//g' | tr -d '\n' | # First remove linebreaks and mutt sidebars:
	grep -aEo "$urlregex" | # grep only urls as defined above.
	uniq | # Ignore neighboring duplicates.
	sed "s/\(\.\|,\|;\|\!\\|\?\)$//;
	s/^www./http:\/\/www\./")" # xdg-open will not detect url without http

[ -z "$urls" ] && exit 1

while getopts "hoc" o; do case "${o}" in
	h) printf "Optional arguments for custom use:\\n  -c: copy\\n  -o: xdg-open\\n  -h: Show this message\\n" && exit 1 ;;
	o) chosen="$(echo "$urls" | rofi -dmenu -i -p "follow url:" -theme links)"
	setsid xdg-open "$chosen" >/dev/null 2>&1 & ;;
	c) echo "$urls" | rofi -dmenu -i -p "copy url:" -theme links | tr -d '\n' | xclip -selection clipboard ;;
	*) printf "Invalid option: -%s\\n" "$OPTARG" && exit 1 ;;
esac done
