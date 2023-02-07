#!/usr/bin/env bash

if [ "$1" = "--env" ]; then
    mkdir -p ~/.config/zsh
    ln -fs ~/.config/dotfiles/zsh/zshenv ~/.config/zsh/.zshenv
    ln -fs ~/.config/dotfiles/zsh/zshenv ~/.xprofile
    exit
fi

if [ "$1" = "--full" ]; then
    rm -rf ~/.config/latexmk 2>/dev/null
    rm -rf ~/.config/npm     2>/dev/null
    rm -rf ~/.config/nvim    2>/dev/null
    rm -rf ~/.config/rofi    2>/dev/null
    rm -rf ~/.config/tmux    2>/dev/null
    rm -rf ~/.config/zsh     2>/dev/null
    rm -rf ~/.config/mpv     2>/dev/null
    rm -rf ~/.config/wget    2>/dev/null

    mkdir -p ~/.config/git
    mkdir -p ~/.config/latexmk
    mkdir -p ~/.config/npm
    mkdir -p ~/.config/rofi
    mkdir -p ~/.config/tmux
    mkdir -p ~/.config/zsh
    mkdir -p ~/.config/mpv/scripts
    mkdir -p ~/.config/mpv/script-opts
    mkdir -p ~/.config/wget
    mkdir -p ~/.config/zathura

    mkdir -p ~/.local/share/fonts
    mkdir -p ~/.local/share/applications
    mkdir -p ~/.local/bin

    # /home cleanup directories
    mkdir -p ~/.cache/nv
    mkdir -p ~/.cache/texlive
    mkdir -p ~/.config/docker
    mkdir -p ~/.config/grip
    mkdir -p ~/.config/gtk-2.0
    mkdir -p ~/.config/java
    mkdir -p ~/.config/jupyter
    mkdir -p ~/.config/npm
    mkdir -p ~/.config/nvim
    mkdir -p ~/.local/share/cargo
    mkdir -p ~/.local/share/gnupg
    mkdir -p ~/.local/share/gradle
    mkdir -p ~/.local/share/rustup
    mkdir -p ~/.local/share/zoom
    mkdir -p ~/.local/share/zsh
fi

cd ~ || exit

# symlinked folders need to be removed before linking
rm -rf ~/.config/nvim/UltiSnips
rm -rf ~/.config/awesome
rm -rf ~/.config/nvim/lua
rm -rf ~/.config/nvim/queries
rm -rf ~/.config/nvim/after
rm -rf ~/.config/nvim/bin
rm -rf ~/.config/nvim/init.lua
rm -rf ~/.config/nvim/lazy-lock.json
ln -fs ~/.config/dotfiles/vim/snippets           ~/.config/nvim/UltiSnips
ln -fs ~/.config/dotfiles/vim/lua                ~/.config/nvim/lua
ln -fs ~/.config/dotfiles/vim/queries            ~/.config/nvim/queries
ln -fs ~/.config/dotfiles/vim/after              ~/.config/nvim/after
ln -fs ~/.config/dotfiles/vim/bin                ~/.config/nvim/bin
ln -fs ~/.config/dotfiles/vim/init.lua           ~/.config/nvim/
ln -fs ~/.config/dotfiles/vim/lazy-lock.json     ~/.config/nvim/
ln -fs ~/.config/dotfiles/awesome                ~/.config/awesome

ln -fs ~/.config/dotfiles/git/gitconfig          ~/.config/git/config
ln -fs ~/.config/dotfiles/misc/latexmkrc         ~/.config/latexmk/
ln -fs ~/.config/dotfiles/rofi/base.rasi         ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/drun.rasi         ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/power.rasi        ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/screenshot.rasi   ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/links.rasi        ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/eq.rasi           ~/.config/rofi/
ln -fs ~/.config/dotfiles/misc/starship.toml     ~/.config/
ln -fs ~/.config/dotfiles/misc/tmux.conf         ~/.config/tmux/
ln -fs ~/.config/dotfiles/zsh/zlogout            ~/.config/zsh/.zlogout
ln -fs ~/.config/dotfiles/zsh/zshrc              ~/.config/zsh/.zshrc
ln -fs ~/.config/dotfiles/mpv/input.conf         ~/.config/mpv/
ln -fs ~/.config/dotfiles/mpv/mpv.conf           ~/.config/mpv/
ln -fs ~/.config/dotfiles/mpv/osc.conf           ~/.config/mpv/script-opts/
ln -fs ~/.config/dotfiles/mpv/appendURL.lua      ~/.config/mpv/scripts/
ln -fs ~/.config/dotfiles/mpv/all_audio.lua      ~/.config/mpv/scripts/
ln -fs ~/.config/dotfiles/mpv/cut_video.lua      ~/.config/mpv/scripts/
ln -fs ~/.config/dotfiles/misc/wgetrc            ~/.config/wget/
ln -fs ~/.config/dotfiles/misc/zathurarc         ~/.config/zathura/
ln -fs ~/.config/dotfiles/misc/st.desktop        ~/.local/share/applications/

ln -fs ~/.config/dotfiles/scripts/wallpaper/wallpaper.desktop ~/.local/share/applications/

# set default apps
if [ "$(hostname)" != "Yellow-Lion.local" ]; then
    xdg-mime default org.pwmt.zathura.desktop     application/pdf
    xdg-mime default org.gnome.eog.desktop        image/png
    xdg-mime default org.gnome.eog.desktop        image/jpg
    xdg-mime default org.gnome.eog.desktop        image/jpeg
    xdg-mime default org.gnome.eog.desktop        image/webp
    xdg-mime default org.gnome.eog.desktop        image/x-portable-pixmap
    xdg-mime default org.gnome.gedit.desktop      text/plain
    xdg-mime default org.gnome.gedit.desktop      text/csv
    xdg-mime default org.gnome.gedit.desktop      text/xml
    xdg-mime default org.gnome.gedit.desktop      application/json
    xdg-mime default org.gnome.FileRoller.desktop application/zip
    xdg-mime default mpv.desktop                  audio/mpeg
    xdg-mime default mpv.desktop                  image/gif
    xdg-mime default mpv.desktop                  audio/flac
    xdg-mime default mpv.desktop                  audio/x-aiff
    xdg-mime default mpv.desktop                  video/x-matroska
    xdg-mime default mpv.desktop                  video/mp4
fi

if [ "$1" = "--full" ]; then
    cp ~/.config/dotfiles/misc/npmrc             ~/.config/npm/

    cp ~/.config/dotfiles/font/JetBrains_Mono_Regular_Nerd_Font_Complete_Mono.ttf ~/.local/share/fonts/
    sudo fc-cache -fv && fc-cache -fv
fi

echo
echo "Finished deployment"
