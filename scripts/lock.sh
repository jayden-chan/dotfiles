#!/bin/sh

# system-d lock script. 
# * Place in /usr/lib/systemd/system-sleep/lock.sh
# * sudo chmod a+x /usr/lib/systemd/system-sleep/lock.sh

case $1/$2 in
    pre/*)
        XDG_SEAT_PATH="/org/freedesktop/DisplayManager/Seat0" dm-tool lock
        ;;
esac
