#!/bin/sh

dateStart=$(date +'%a, %b')
dayOfMonth=$(date +'%e' | sed 's/^ *//;s/ *$//')
time=$(date +'%l:%M %P')

echo $dateStart $dayOfMonth\ $time

