#!/usr/bin/env bash

msg () {
    echo "[autostart] [$(date)] $1"
}

shopt -s expand_aliases
alias rga='rg --color=never >/dev/null'

exec > /tmp/autostart.log 2>&1

nitrogen --restore &

ps_ax="/tmp/autostart_psax";
ps -ax > "$ps_ax"

if [ "$HOSTNAME" = "grace" ]; then
    if ! rga "/share/carla/carla" "$ps_ax"; then
        msg "starting carla"
        carla "$HOME/.config/Carla.carxp" &
    fi

    if ! rga "sensors-mon" "$ps_ax"; then
        # we'll sleep for a couple seconds so that
        # sensors-mon starts up after carla and goes into
        # the right place in the tiling window manager
        # hierarchy
        sleep 2

        msg "starting sensors-mon"
        alacritty --class="sensors-mon" -e sensors-mon 2>/dev/null &
    fi
fi
