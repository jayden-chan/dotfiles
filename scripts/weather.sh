#!/bin/sh

weatherTemp=$(curl --silent "api.openweathermap.org/data/2.5/weather?q=Victoria,CA&appid=bdd632865ceed4ed50968235ef201e6a&units=metric" | jq -r ".main.temp")

echo $weatherTemp C
