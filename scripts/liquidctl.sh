#!/usr/bin/env bash

level_file="/tmp/liquidctl_level"
if [ ! -f "$level_file" ]; then
    echo -n "1" > "$level_file"
fi

fan1="fan1"
fan2="fan3"
pump="fan2"
level="$1"

if [ "$2" = "--automated" ]; then
    notify-send -u critical "liquidctl" "WARNING: Cooling level was set automatically"
fi

case "$level" in
    1) liquidctl --match Aquacomputer set "$fan1" speed 43 && \
       liquidctl --match Aquacomputer set "$fan2" speed 42 && \
       liquidctl --match Aquacomputer set "$pump" speed 20
           ;;
    2) liquidctl --match Aquacomputer set "$fan1" speed 55 && \
       liquidctl --match Aquacomputer set "$fan2" speed 55 && \
       liquidctl --match Aquacomputer set "$pump" speed 35
           ;;
    3) liquidctl --match Aquacomputer set "$fan1" speed 63 && \
       liquidctl --match Aquacomputer set "$fan2" speed 63 && \
       liquidctl --match Aquacomputer set "$pump" speed 35
           ;;
    4) liquidctl --match Aquacomputer set "$fan1" speed 72 && \
       liquidctl --match Aquacomputer set "$fan2" speed 72 && \
       liquidctl --match Aquacomputer set "$pump" speed 35
           ;;
    5) liquidctl --match Aquacomputer set "$fan1" speed 100 && \
       liquidctl --match Aquacomputer set "$fan2" speed 100 && \
       liquidctl --match Aquacomputer set "$pump" speed 35
           ;;
esac

echo -n "$level" > "$level_file"
notify-send "liquidctl" "Cooling set to level $level"
