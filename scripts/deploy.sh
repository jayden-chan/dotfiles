#!/usr/bin/env bash

if [ "$1" = "--full" ]; then
    rm -rf ~/.config/npm         2>/dev/null
    rm -rf ~/.config/nvim        2>/dev/null
    rm -rf ~/.config/rofi        2>/dev/null
    rm -rf ~/.config/tmux        2>/dev/null
    rm -rf ~/.config/zsh         2>/dev/null
    rm -rf ~/.config/mpv         2>/dev/null

    mkdir -p ~/.config/git
    mkdir -p ~/.config/npm
    mkdir -p ~/.config/rofi
    mkdir -p ~/.config/tmux
    mkdir -p ~/.config/zsh
    mkdir -p ~/.config/mpv/scripts

    mkdir -p ~/.local/share/applications
    mkdir -p ~/.local/bin

    # /home cleanup directories
    mkdir -p ~/.cache/nv
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
    mkdir -p ~/.local/share/zsh
fi

cd ~ || exit

# symlinked folders need to be removed before linking
rm -rf ~/.config/awesome
rm -rf ~/.config/nvim/lua
rm -rf ~/.config/nvim/queries
rm -rf ~/.config/nvim/after
rm -rf ~/.config/nvim/init.lua
rm -rf ~/.config/nvim/lazy-lock.json

ln -fs ~/.config/dotfiles/vim/lua                               ~/.config/nvim/lua
ln -fs ~/.config/dotfiles/vim/queries                           ~/.config/nvim/queries
ln -fs ~/.config/dotfiles/vim/after                             ~/.config/nvim/after
ln -fs ~/.config/dotfiles/vim/init.lua                          ~/.config/nvim/
ln -fs ~/.config/dotfiles/vim/lazy-lock.json                    ~/.config/nvim/
ln -fs ~/.config/dotfiles/awesome/theme                         ~/.config/awesome/theme
ln -fs ~/.config/dotfiles/awesome/rc.lua                        ~/.config/awesome/
ln -fs ~/.config/dotfiles/git/gitconfig                         ~/.config/git/config
ln -fs ~/.config/dotfiles/rofi/base.rasi                        ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/drun.rasi                        ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/power.rasi                       ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/screenshot.rasi                  ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/links.rasi                       ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/eq.rasi                          ~/.config/rofi/
ln -fs ~/.config/dotfiles/misc/tmux.conf                        ~/.config/tmux/
ln -fs ~/.config/dotfiles/zsh/zlogout                           ~/.config/zsh/.zlogout
ln -fs ~/.config/dotfiles/zsh/zshrc                             ~/.config/zsh/.zshrc
ln -fs ~/.config/dotfiles/mpv/appendURL.lua                     ~/.config/mpv/scripts/
ln -fs ~/.config/dotfiles/mpv/all_audio.lua                     ~/.config/mpv/scripts/
ln -fs ~/.config/dotfiles/mpv/cut_video.lua                     ~/.config/mpv/scripts/

echo
echo "Finished deployment"
