#!/usr/bin/env bash

msg () {
    echo "[autostart] $1"
}

shopt -s expand_aliases
alias rga='rg --color=never >/dev/null'

exec >/home/jayden/.cache/autostart.log 2>&1

ps_ax="/tmp/autostart_psax";
ps -ax > "$ps_ax"

if ! rga "picom --config $DOT/misc/picom.conf" "$ps_ax"; then
    msg "starting picom"
    picom --config "$DOT/misc/picom.conf" &
fi

if ! rga "/bin/redshift" "$ps_ax"; then
    msg "starting redshift"
    redshift &
fi

if ! rga "/bin/thunar --daemon" "$ps_ax"; then
    msg "starting thunar daemon"
    thunar --daemon &
fi

if ! rga "/share/carla/carla" "$ps_ax"; then
    msg "starting carla"
    carla "$HOME/.config/Carla.carxp" &
fi

if [ "$HOST" = "grace" ]; then
    if ! rga "auto-cool.sh" "$ps_ax"; then
        msg "starting auto-cool script"
        "$DOT/scripts/auto-cool.sh" &
    fi
fi

nitrogen --restore &
