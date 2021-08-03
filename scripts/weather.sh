#!/usr/bin/dash

[ -e "$HOME/.config/ENV" ] && . $HOME/.config/ENV

# default city Victoria BC
city=${WEATHER_CITY_ID:-6174041}
browser=${BROWSER:-firefox}

if [ "$1" = "--open" ]; then $browser https://openweathermap.org/city/$city; exit; fi
if [ -z "$WEATHER_TOKEN" ]; then echo "No token"; exit 1; fi

url="api.openweathermap.org/data/2.5/weather?id=$city&units=metric&appid=$WEATHER_TOKEN"
curl --silent "$url" | jq -r '"  \(.weather[0].description), \(.main.feels_like | round)C"'
