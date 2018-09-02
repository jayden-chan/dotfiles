#!/bin/sh
weatherTemp=$(curl --silent https://query.yahooapis.com/v1/public/yql\?q\=select%20item.condition%20from%20weather.forecast%20where%20woeid%20in%20\(select%20woeid%20from%20geo.places\(1\)%20where%20text%3D%22saanich%2C%20bc%22\)%20and%20u%20%3D%20%22c%22\&format\=json\&env\=store%3A%2F%2Fdatatables.org%2Falltableswithkeys | jq -r ".query.results.channel.item.condition.temp")
dateStart=$(date +'%a, %b')
dayOfMonth=$(date +'%e' | sed 's/^ *//;s/ *$//')
time=$(date +'%l:%M %P')

echo $dateStart $dayOfMonth\ \ $time\ \ $weatherTemp C

