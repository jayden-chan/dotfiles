#!/usr/bin/env bash

[ -e "$HOME/.config/ENV" ] && . "$HOME"/.config/ENV

city="$WEATHER_CITY"

if [ "$city" = "" ]; then
    echo "weather city not set"
    exit
fi

if [ "$1" = "--open" ]; then xdg-open "https://cron.jayden.codes/weather/open/$city"; exit; fi

if [ -z "$HA_TOKEN" ]; then
    indoor_temp=""
else
    ha_temp="$(curl -X GET \
        -H "authorization: Bearer $HA_TOKEN" \
        -H "content-type: application/json" \
        https://homeassistant.jayden.codes/api/states/sensor.temp_sensor_1_temperature \
        | jq -r '.state | tonumber * 10 | round / 10')"

    if [ -n "$ha_temp" ] && [ "$ha_temp" != "unavailable" ]; then
        indoor_temp=" (${ha_temp}C)"
    fi
fi

weather=$(curl --silent "https://cron.jayden.codes/weather/short/$city")
echo "$weather$indoor_temp"
