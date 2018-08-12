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

export apps="
evince
gimp
htop
nautilus
pavucontrol
qiv
scrot
vlc
libreoffice-fresh
gpick
flashplugin
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
dep
docker
diff-so-fancy
neovim
python-neovim
"

export system="
arandr
compton
dunst
i3-gaps
lightdm
lightdm-gtk-greeter
perl-anyevent-i3
numlockx
pulseaudio
rofi
termite
"

export cli="
curl
lastpass-cli
mlocate
imagemagick
neofetch
unzip
which
openssh
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
"

echo Updating system...
sudo pacman -Syu

echo "Installing CLI tools... [1/5]"
for p in $cli
do
    sudo pacman -S --needed --noconfirm $p
done

echo "Installing dev tools... [2/5]"
for p in $dev
do
    sudo pacman -S --needed --noconfirm $p
done

echo "Installing system tools... [3/5]"
for p in $system
do
    sudo pacman -S --needed --noconfirm $p
done

echo "Installing theme tools... [4/5]"
for p in $theme
do
    sudo pacman -S --needed --noconfirm $p
done

echo "Installing applications... [5/5]"
for p in $apps
do
    sudo pacman -S --needed --noconfirm $p
done

echo "Installing yay AUR package"
echo "cd ~/Downloads"
cd ~/Downloads

echo "git clone https://aur.archlinux.org/yay.git"
git clone https://aur.archlinux.org/yay.git

echo "cd yay"
cd yay

echo "makepkg -si"
makepkg -si

echo "Installing AUR packages"
yay -S google-cloud-sdk-minimal insomnia polybar spotify

echo
echo "Software setup complete.
