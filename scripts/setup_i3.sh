#!/bin/sh

echo -n "WARNING: This script is intended to be run on a fresh Arch installation
with sudo and users/groups and folders properly set up. I don't know what will happen
if you run it in any other scenario.

"

echo -n "Continue? [Y/n] "
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo Running setup script...
else
    echo Aborting
    exit 0
fi

export swift="
alsa-utils
arm-none-eabi-gdb
bluez
bluez-utils
blueman
pulseaudio-bluetooth
"

export aur="
google-cloud-sdk
insomnia
polybar
spotify
heroku-cli
git-extras
gotop-bin
xcolor
powerline-fonts-git
"

export apps="
evince
gimp
nautilus
pavucontrol
feh
maim
vlc
libreoffice-fresh
flashplugin
neovim
python-neovim
firefox
"

export dev="
git
cmake
fakeroot
gcc
gdb
jdk8-openjdk
make
autoconf
bison
nodejs
npm
python
python-pip
python-pylint
rustup
go
docker
diff-so-fancy
ctags
postgresql
"

export system="
arandr
picom
cups
awesome
lightdm
lightdm-gtk-greeter
numlockx
pulseaudio
rofi
kitty
ntp
fzf
jq
ripgrep
htop
iputils
ponymix
android-file-transfer
ntfs-g3
"

export cli="
curl
bat
exa
transmission-cli
mlocate
imagemagick
texlive-most
biber
neofetch
unzip
which
openssh
graphviz
xclip
xorg-server
xorg-xinput
xorg-xmodmap
xorg-xprop
xorg-xrdb
"

export theme="
lxappearance
nitrogen
papirus-icon-theme
lightdm-gtk-greeter-settings
python-pywal
arc-gtk-theme
ttf-fira-code
nerd-fonts-complete
"

echo Updating system...
sudo pacman -Syu

echo "Installing CLI tools... [1/7]"
for p in $cli
do
    sudo pacman -S --needed --noconfirm $p
done

echo "Installing dev tools... [2/7]"
for p in $dev
do
    sudo pacman -S --needed --noconfirm $p
done

echo "Installing system tools... [3/7]"
for p in $system
do
    sudo pacman -S --needed --noconfirm $p
done

echo "Installing theme tools... [4/7]"
for p in $theme
do
    sudo pacman -S --needed --noconfirm $p
done

echo "Installing applications... [5/7]"
for p in $apps
do
    sudo pacman -S --needed --noconfirm $p
done

echo "Installing yay AUR package... [6/7]"
set -v

cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si && cd .. && rm -rf yay

set +v
echo "Installing AUR packages"
for p in $aur
do
    yay -S $p --nocomfirm
done

echo "Installing laptop-specific packages... [7/7]"
if [ $(hostname) = "swift" ]; then
    for p in $swift
    do
        sudo pacman -S -needed --noconfirm $p
    done
    yay -S light
else
    echo "Laptop hostname not detected, not installing packages"
fi

echo
echo "Software setup complete. Enable the following systemd services:
    lightdm
    acpid
    docker
    NetworkManager (may already be enabled)
    ntpd"
