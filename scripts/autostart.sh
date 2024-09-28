#!/usr/bin/env bash

msg () {
    echo "[autostart] $1"
}

shopt -s expand_aliases
alias rga='rg --color=never >/dev/null'

exec > "$HOME/.cache/autostart.log" 2>&1

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

if ! rga "notifications-dbus-mon" "$ps_ax"; then
    msg "starting notifications-dbus-mon"
    notifications-dbus-mon &
fi

if [ "$HOSTNAME" = "grace" ]; then
    if ! rga "auto-cool.sh" "$ps_ax"; then
        msg "starting auto-cool script"
        "$DOT/scripts/auto-cool.sh" &
    fi

    if ! rga "psensor" "$ps_ax"; then
        msg "starting psensor"

        # we'll sleep for a couple seconds so that
        # psensor starts up after carla and goes into
        # the right place in the tiling window manager
        # hierarchy
        sleep 2

        psensor 2>/dev/null &
    fi
fi

nitrogen --restore &
