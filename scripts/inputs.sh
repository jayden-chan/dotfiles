#!/bin/zsh

# https://unix.stackexchange.com/questions/491531/how-to-avoid-mouse-cursor-jumping-while-using-xinput-coordinate-transformation-m
#
# My "solution" was to pick a transformation matrix that keeps the cursor in
# place when it is centered.
#
# The matrix you want to use is:
#
# ┌            ┐
# │ s 0 (1-s)x │
# │ 0 s (1-s)y │
# │ 0 0   1    │
# └            ┘
# 3 by 3 matrix s 0 (1-s)x 0 s (1-s)y 0 0 1
#
# Where s is the scaling factor you want for your mouse, e.g. 0.5 for half
# speed. And x and y are the coordinates for the center of your screen.
#
# An easy way to get the x,y value is with xdotool getmouselocation before a
# jump.
#
# Example
#
# I wanted my sensitivity s = 0.4
#
# After opening my inventory in minecraft, xdotool getmouseloation reports my x
# = 960 and y = 1729. Calculating my offsets (1-s)*x = 0.6*960 = 576 and
# (1-s)*y = 0.6*1729 = 1037.4
#
# I then changed the Coordinate transformation matrix accordingly
#
# xinput set-prop 8 'Coordinate Transformation Matrix' 0.4 0 576 0 0.4 1037.4 0 0 1
#
# (My mouse is device 8 will likely be different for you.)
function mouse_sens () {
    id="$1"
    s="$2"
    x="2880"
    y="540"

    sx=$(bc -l <<< "(1 - $s) * $x")
    sy=$(bc -l <<< "(1 - $s) * $y")
    # xinput --set-prop "$id" 'Coordinate Transformation Matrix' "$s" 0 "$sx" 0 "$s" "$sy" 0 0 1
    # xinput --set-prop "$id" 'Coordinate Transformation Matrix' "1" 0 "1" 0 "1" "1" 0 0 1
    xinput --set-prop "$id" 'libinput Accel Profile Enabled' 0 1
    xinput --set-prop "$id" 'libinput Accel Speed' 0
}

gspeed=3.8
for id in `xinput --list | rg 'Logitech Gaming Mouse G502\s+id=(\d+)\s+\[slave\s+pointer' --only-matching --replace='$1'`; do
    mouse_sens "$id" "$gspeed"
done

mouse_sens "pointer:Glorious Model O" "1.8"
mouse_sens "pointer:Logitech MX Master" "1.9"

xinput --set-prop 'SYNA2B2C:01 06CB:7F27 Touchpad' 'libinput Natural Scrolling Enabled' 0
xinput --set-prop 'SYNA2B2C:01 06CB:7F27 Touchpad' 'libinput Tapping Enabled' 1

hspeed=1.8
xinput --set-prop 'HP HP Link-5 micro dongle Mouse' 'Coordinate Transformation Matrix' $hspeed 0.0 0.0 0.0 $hspeed 0.0 0.0 0.0 1.0
xinput --set-prop 'HP HP Link-5 micro dongle Mouse' 'libinput Accel Speed' -1

xset r rate 270 35
xmodmap -e "clear lock" &
xmodmap -e "keysym Caps_Lock = Escape" &
