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
    if ! rga "bash .*auto-cool.sh" "$ps_ax"; then
        msg "starting auto-cool script"
        "$DOT/scripts/auto-cool.sh" &
    fi

    if ! rga "sensors-mon" "$ps_ax"; then
        # we'll sleep for a couple seconds so that
        # sensors-mon starts up after carla and goes into
        # the right place in the tiling window manager
        # hierarchy
        sleep 2

        msg "starting sensors-mon"
        ghostty --x11-instance-name="sensors-mon" -e sensors-mon 2>/dev/null &
    fi
fi
