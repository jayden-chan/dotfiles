#!/bin/sh

weatherTemp=$(curl --silent "api.openweathermap.org/data/2.5/weather?id=6174041&appid=bdd632865ceed4ed50968235ef201e6a&units=metric" | jq -r ".main.temp" | awk '{printf("%.0f\n", $1)}')

echo $weatherTemp C
