#!/usr/bin/dash

hidden=$(bspc query -N -n .hidden.local.window)
case $? in
  0) bspc node $hidden --flag hidden=off --focus ;;
  1) bspc node --flag hidden=on ;;
esac
