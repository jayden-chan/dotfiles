#!/usr/bin/dash

case "$1" in
    vol)
        case "$2" in
            up) pactl set-sink-volume @DEFAULT_SINK@ +1000 ;;
            down) pactl set-sink-volume @DEFAULT_SINK@ -1000 ;;
            mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
        esac

        currvol=$(pactl get-sink-volume @DEFAULT_SINK@ | rg 'front-left: \d+\s+/\s+(\d+)%' --only-matching --replace '$1')
        muted=$(pactl get-sink-mute @DEFAULT_SINK@ | rg ':\s+(\w+)' --only-matching --replace '$1'); \
        notify-send "Volume $currvol% [muted: $muted]" -h int:value:"$currvol" -h string:synchronous:volume
        ;;

    media)
        dbusdomain="org.mpris.MediaPlayer2"
        dbus-send --print-reply --dest="$dbusdomain".spotify /org/mpris/MediaPlayer2 "$dbusdomain".Player."$2"
        ;;

    light)
        currbrightness=$(light | awk '{print int($1+0.5)}')
        case "$2" in
            up) 
                [ "$currbrightness" -lt 100 ] && stepamt=10
                [ "$currbrightness" -lt 30 ] && stepamt=5
                [ "$currbrightness" -lt 10 ] && stepamt=1
                light -A $stepamt
                ;;
            down) 
                [ "$currbrightness" -le 100 ] && stepamt=10
                [ "$currbrightness" -le 30 ] && stepamt=5
                [ "$currbrightness" -le 10 ] && stepamt=1
                light -U $stepamt
                ;;
        esac
        currbrightness=$(light | awk '{print int($1+0.5)}')
        notify-send "Brightness $currbrightness%" -h int:value:"$currbrightness" -h string:synchronous:brightness
esac
