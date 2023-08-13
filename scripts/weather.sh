#!/usr/bin/dash

[ -e "$HOME/.config/ENV" ] && . "$HOME"/.config/ENV

# default city Victoria BC
city=${WEATHER_CITY_ID:-6174041}

if [ "$1" = "--open" ]; then xdg-open https://openweathermap.org/city/"$city"; exit; fi
if [ -z "$WEATHER_TOKEN" ]; then echo "No weather token"; exit 1; fi

if [ -z "$HA_TOKEN" ]; then
    indoor_temp=""
else
    ha_temp="$(ha desk_temp)"
    if [ -n "$ha_temp" ] && [ "$ha_temp" != "unavailable" ]; then
        indoor_temp=" (${ha_temp}C)"
    fi
fi

url="api.openweathermap.org/data/2.5/weather?id=$city&units=metric&appid=$WEATHER_TOKEN"
weather_file="$XDG_CACHE_HOME/weather"
curr_time=$(date +'%s')

if [ -f "$weather_file" ]; then
    cached_weather=$(cut -f1 < "$weather_file")
    weather_time=$(cut -f2 < "$weather_file")
    time_diff=$(echo "$curr_time - $weather_time" | bc -l)

    if [ "$time_diff" -gt "600" ]; then
        weather_response=$(curl curl --silent "$url")
        weather_code=$?
        if [ "$weather_code" = "0" ]; then
            weather=$(echo "$weather_response" | jq -r '"\(.weather[0].description), \(.main.feels_like | round)C"')
            echo "$weather	$curr_time" > "$weather_file"
        fi
    else
        weather="$cached_weather"
    fi
else
    weather_response=$(curl curl --silent "$url")
    weather_code=$?
    if [ "$weather_code" = "0" ]; then
        weather=$(echo "$weather_response" | jq -r '"\(.weather[0].description), \(.main.feels_like | round)C"')
        echo "$weather	$curr_time" > "$weather_file"
    fi
fi

echo "$weather$indoor_temp"
