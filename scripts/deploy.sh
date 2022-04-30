#!/usr/bin/dash

if [ "$1" = "--env" ]; then
    ln -fs ~/.config/dotfiles/zsh/zshenv ~/.config/zsh/.zshenv
    ln -fs ~/.config/dotfiles/zsh/zshenv ~/.xprofile
    exit
fi

if [ "$1" = "--full" ]; then
    rm -rf ~/.config/bspwm   2>/dev/null
    rm -rf ~/.config/latexmk 2>/dev/null
    rm -rf ~/.config/npm     2>/dev/null
    rm -rf ~/.config/nvim    2>/dev/null
    rm -rf ~/.config/rofi    2>/dev/null
    rm -rf ~/.config/tmux    2>/dev/null
    rm -rf ~/.config/zsh     2>/dev/null
    rm -rf ~/.config/mpv     2>/dev/null

    mkdir -p ~/.config/bspwm
    mkdir -p ~/.config/git
    mkdir -p ~/.config/latexmk
    mkdir -p ~/.config/npm
    mkdir -p ~/.config/nvim/colors
    mkdir -p ~/.config/rofi
    mkdir -p ~/.config/tmux
    mkdir -p ~/.config/zsh
    mkdir -p ~/.config/mpv/scripts
    mkdir -p ~/.config/mpv/script-opts

    mkdir -p ~/.local/share/fonts
    mkdir -p ~/.local/bin
fi

cd ~
ln -fs ~/.config/dotfiles/bspwm/bspwmrc          ~/.config/bspwm/
ln -fs ~/.config/dotfiles/git/gitconfig          ~/.config/git/config
ln -fs ~/.config/dotfiles/misc/latexmkrc         ~/.config/latexmk/
ln -fs ~/.config/dotfiles/rofi/base.rasi         ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/drun.rasi         ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/power.rasi        ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/screenshot.rasi   ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/links.rasi        ~/.config/rofi/
ln -fs ~/.config/dotfiles/rofi/eq.rasi           ~/.config/rofi/
ln -fs ~/.config/dotfiles/snippets/              ~/.config/nvim/UltiSnips
ln -fs ~/.config/dotfiles/misc/starship.toml     ~/.config/
ln -fs ~/.config/dotfiles/misc/tmux.conf         ~/.config/tmux/
ln -fs ~/.config/dotfiles/vim/coc-settings.json  ~/.config/nvim/
ln -fs ~/.config/dotfiles/vim/vimrc              ~/.config/nvim/init.vim
ln -fs ~/.config/dotfiles/zsh/zlogout            ~/.config/zsh/.zlogout
ln -fs ~/.config/dotfiles/zsh/zshrc              ~/.config/zsh/.zshrc
ln -fs ~/.config/dotfiles/scripts/p.js           ~/.local/bin/p
ln -fs ~/.config/dotfiles/mpv/input.conf         ~/.config/mpv/
ln -fs ~/.config/dotfiles/mpv/mpv.conf           ~/.config/mpv/
ln -fs ~/.config/dotfiles/mpv/osc.conf           ~/.config/mpv/script-opts/
ln -fs ~/.config/dotfiles/mpv/appendURL.lua      ~/.config/mpv/scripts/
ln -fs ~/.config/dotfiles/easyeffects/HE400.json ~/.config/easyeffects/output/HE400i\ oratory1900.json
ln -fs ~/.config/dotfiles/easyeffects/QC35.json  ~/.config/easyeffects/output/QC35\ Wired\ Active.json
ln -fs ~/.config/dotfiles/easyeffects/Mic.json   ~/.config/easyeffects/input/Mic.json

if [ "$1" = "--full" ]; then
    cp ~/.config/dotfiles/misc/npmrc             ~/.config/npm/

    cp ~/.config/dotfiles/font/JetBrains_Mono_Regular_Nerd_Font_Complete_Mono.ttf ~/.local/share/fonts/
    sudo fc-cache -fv
fi

echo
echo "Finished deployment"
