#!/usr/bin/env bash

if [ "$1" = "--full" ]; then
    rm -rf ~/.config/npm         2>/dev/null
    rm -rf ~/.config/nvim        2>/dev/null
    rm -rf ~/.config/rofi        2>/dev/null
    rm -rf ~/.config/tmux        2>/dev/null
    rm -rf ~/.config/zsh         2>/dev/null
    rm -rf ~/.config/mpv         2>/dev/null
    rm -rf ~/.config/wget        2>/dev/null
    rm -rf ~/.config/mprocs      2>/dev/null
    rm -rf ~/.config/lazygit     2>/dev/null
    rm -rf ~/.config/direnv      2>/dev/null
    rm -rf ~/.config/atuin       2>/dev/null

    rm -f ~/.config/pipewire/jack.conf           2>/dev/null
    rm -f ~/.config/pipewire/pipewire.conf       2>/dev/null
    rm -f ~/.config/pipewire/pipewire-pulse.conf 2>/dev/null

    mkdir -p ~/.config/git
    mkdir -p ~/.config/npm
    mkdir -p ~/.config/rofi
    mkdir -p ~/.config/tmux
    mkdir -p ~/.config/zsh
    mkdir -p ~/.config/mpv/scripts
    mkdir -p ~/.config/mpv/script-opts
    mkdir -p ~/.config/wget
    mkdir -p ~/.config/mprocs
    mkdir -p ~/.config/zathura
    mkdir -p ~/.config/lazygit
    mkdir -p ~/.config/pipewire
    mkdir -p ~/.config/direnv
    mkdir -p ~/.config/atuin

    mkdir -p ~/.local/share/fonts
    mkdir -p ~/.local/share/applications
    mkdir -p ~/.local/bin

    # /home cleanup directories
    mkdir -p ~/.cache/nv
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
ln -fs ~/.config/dotfiles/misc/starship.toml                    ~/.config/
ln -fs ~/.config/dotfiles/misc/tmux.conf                        ~/.config/tmux/
ln -fs ~/.config/dotfiles/zsh/zlogout                           ~/.config/zsh/.zlogout
ln -fs ~/.config/dotfiles/zsh/zshrc                             ~/.config/zsh/.zshrc
ln -fs ~/.config/dotfiles/mpv/input.conf                        ~/.config/mpv/
ln -fs ~/.config/dotfiles/mpv/mpv.conf                          ~/.config/mpv/
ln -fs ~/.config/dotfiles/mpv/osc.conf                          ~/.config/mpv/script-opts/
ln -fs ~/.config/dotfiles/mpv/appendURL.lua                     ~/.config/mpv/scripts/
ln -fs ~/.config/dotfiles/mpv/all_audio.lua                     ~/.config/mpv/scripts/
ln -fs ~/.config/dotfiles/mpv/cut_video.lua                     ~/.config/mpv/scripts/
ln -fs ~/.config/dotfiles/misc/wgetrc                           ~/.config/wget/
ln -fs ~/.config/dotfiles/misc/mprocs.yaml                      ~/.config/mprocs/
ln -fs ~/.config/dotfiles/misc/zathurarc                        ~/.config/zathura/
ln -fs ~/.config/dotfiles/misc/lazygit.yml                      ~/.config/lazygit/config.yml
ln -fs ~/.config/dotfiles/pipewire/pipewire.conf                ~/.config/pipewire/
ln -fs ~/.config/dotfiles/pipewire/pipewire-pulse.conf          ~/.config/pipewire/
ln -fs ~/.config/dotfiles/pipewire/jack.conf                    ~/.config/pipewire/
ln -fs ~/.config/dotfiles/misc/direnv.toml                      ~/.config/direnv/
ln -fs ~/.config/dotfiles/misc/atuin.toml                       ~/.config/atuin/config.toml

ln -fs ~/.config/dotfiles/misc/chromium_mullvad.desktop         ~/.local/share/applications/
ln -fs ~/.config/dotfiles/scripts/wallpaper/wallpaper.desktop   ~/.local/share/applications/

echo
echo "Finished deployment"
