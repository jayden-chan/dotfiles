#!/bin/bash

fan1="fan1"
fan2="fan3"
pump="fan2"
level="$1"

if [ "$level" = "level1" ]; then
    liquidctl --match Aquacomputer set "$fan1" speed 46 && \
    liquidctl --match Aquacomputer set "$fan2" speed 45 && \
    liquidctl --match Aquacomputer set "$pump" speed 18 && \
    notify-send "liquidctl" "Cooling set to level 1"
fi

if [ "$level" = "level2" ]; then
    liquidctl --match Aquacomputer set "$fan1" speed 63 && \
    liquidctl --match Aquacomputer set "$fan2" speed 63 && \
    liquidctl --match Aquacomputer set "$pump" speed 35 && \
    notify-send "liquidctl" "Cooling set to level 2"
fi

if [ "$level" = "level3" ]; then
    liquidctl --match Aquacomputer set "$fan1" speed 72 && \
    liquidctl --match Aquacomputer set "$fan2" speed 72 && \
    liquidctl --match Aquacomputer set "$pump" speed 35 && \
    notify-send "liquidctl" "Cooling set to level 3"
fi

if [ "$level" = "level4" ]; then
    liquidctl --match Aquacomputer set "$fan1" speed 100 && \
    liquidctl --match Aquacomputer set "$fan2" speed 100 && \
    liquidctl --match Aquacomputer set "$pump" speed 35 && \
    notify-send "liquidctl" "Cooling set to level 4"
fi
