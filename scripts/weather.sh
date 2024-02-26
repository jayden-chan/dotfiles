#!/usr/bin/dash

[ -e "$HOME/.config/ENV" ] && . "$HOME"/.config/ENV

# default city Victoria BC
city=${WEATHER_CITY_ID:-6174041}

if [ "$1" = "--open" ]; then xdg-open https://openweathermap.org/city/"$city"; exit; fi

if [ -z "$HA_TOKEN" ]; then
    indoor_temp=""
else
    ha_temp="$(ha office_temp)"
    if [ -n "$ha_temp" ] && [ "$ha_temp" != "unavailable" ]; then
        indoor_temp=" (${ha_temp}C)"
    fi
fi

weather=$(curl --silent "https://cron.jayden.codes/weather/short/calgary")
echo "$weather$indoor_temp"
