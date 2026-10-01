#!/usr/bin/env bash

set -euo pipefail

port="$(amidi -l | rg 'hw:(\d),0\s+Virtual Raw MIDI' --only-matching --replace='$1' --max-count=1 --color=never)"

# Control change
# Channel 2
# Control function = channel volume
# 0 volume
amidi --port="hw:${port},0" --send-hex="B10700"

sleep 92

# Control change
# Channel 2
# Control function = channel volume
# 127 volume (max)
amidi --port="hw:${port},0" --send-hex="B1077F"
