#!/bin/sh

echo -n "WARNING: This script is intended to be run on a fresh Arch installation
with sudo and users/groups properly set up. I don't know what will happen if you
run it in any other scenario.

"

echo -n "Continue? [Y/n] "
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo Running setup script...
else
    echo Aborting
    exit 0
fi

sudo pacman -Syu

export apps="
evince
gimp
htop
nautilus
pavucontrol
qiv
scrot
vlc
"

export dev="
git
cmake
fakeroot
gcc
jdk8-openjdk
make
autoconf
bison
nodejs
npm
python
python-pip
go
"

export system="
arandr
compton
dunst
i3-gaps
lightdm
lightdm-gtk-greeter
numlockx
pulseaudio
rofi
termite
zsh
"

export cli="
curl
mlocate
imagemagick
neofetch
unzip
which
openssh
xclip
xorg-xinput
xorg-xmodmap
xorg-xprop
xorg-xrdb
"

export theme="
lxappearance
nitrogen
papirus-icon-theme
python-pywal
arc-gtk-theme
"

echo Installing CLI tools...
for p in $cli
do
    sudo pacman -S $p
done

echo Installing dev tools...
for p in $tech
do
    sudo pacman -S $p
done

echo Installing system tools...
for p in $system
do
    sudo pacman -S $p
done

echo Installing theme tools...
for p in $theme
do
    sudo pacman -S $p
done

echo Installing applications...
for p in $apps
do
    sudo pacman -S $p
done

echo "Software setup complete, you must now compile Vim and install the following AUR packages:
    insomnia
    polybar
    spotify

...and install the fonts in /fonts
"
