#!/bin/sh

[ -e "$HOME/.config/ENV" ] && source $HOME/.config/ENV

if [ -z "$WEATHER_TOKEN" ]; then echo "No token"; exit 1; fi

city=${WEATHER_CITY:-Victoria,CA}
url="api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$WEATHER_TOKEN"

curl --silent "$url" | jq -r '"\(.weather[0].description), \(.main.feels_like | round)C"'
