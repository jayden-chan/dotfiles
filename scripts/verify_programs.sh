#!/bin/sh

scriptdir=$HOME/Documents/Git/dotfiles/scripts/setup_i3.sh

echo "Programs not listed in auto-install script:"

for program in $(pacman -Qqettn); do
    rg $program $scriptdir >/dev/null 2>/dev/null || echo "    $program"
done
