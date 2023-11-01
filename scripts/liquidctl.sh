#!/bin/bash

fan1="fan1"
fan2="fan3"
pump="fan2"

if [ "$1" = "low" ]; then
    liquidctl --match Aquacomputer set "$fan1" speed 46 && \
    liquidctl --match Aquacomputer set "$fan2" speed 45 && \
    liquidctl --match Aquacomputer set "$pump" speed 18 && \
    notify-send "liquidctl" "Cooling set to LOW"
fi

if [ "$1" = "high" ]; then
    liquidctl --match Aquacomputer set "$fan1" speed 63 && \
    liquidctl --match Aquacomputer set "$fan2" speed 63 && \
    liquidctl --match Aquacomputer set "$pump" speed 35 && \
    notify-send "liquidctl" "Cooling set to HIGH"
fi

if [ "$1" = "max" ]; then
    liquidctl --match Aquacomputer set "$fan1" speed 100 && \
    liquidctl --match Aquacomputer set "$fan2" speed 100 && \
    liquidctl --match Aquacomputer set "$pump" speed 35 && \
    notify-send "liquidctl" "Cooling set to MAX"
fi
