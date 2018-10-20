#!/bin/sh

rm -r $HOME/.config/compton.conf 2>/dev/null
rm -r $HOME/.config/dunst        2>/dev/null
rm -r $HOME/.config/i3           2>/dev/null
rm -r $HOME/.config/polybar      2>/dev/null
rm -r $HOME/.config/rofi         2>/dev/null
rm -r $HOME/.config/nvim         2>/dev/null
rm -r $HOME/.vim                 2>/dev/null
rm -r $HOME/.config/termite      2>/dev/null

mkdir -p $HOME/.vim
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.config/compton
mkdir -p $HOME/.config/dunst
mkdir -p $HOME/.config/i3
mkdir -p $HOME/.config/polybar
mkdir -p $HOME/.config/rofi
mkdir -p $HOME/.config/termite

ln -fs $HOME/Documents/Git/dotfiles/compton/compton.conf       $HOME/.config/compton.conf
ln -fs $HOME/Documents/Git/dotfiles/dunst/dunstrc              $HOME/.config/dunst/dunstrc
ln -fs $HOME/Documents/Git/dotfiles/git/gitconfig              $HOME/.gitconfig
ln -fs $HOME/Documents/Git/dotfiles/i3/config                  $HOME/.config/i3/config
ln -fs $HOME/Documents/Git/dotfiles/latex/latexmkrc            $HOME/.latexmkrc
ln -fs $HOME/Documents/Git/dotfiles/polybar/config             $HOME/.config/polybar/config
ln -fs $HOME/Documents/Git/dotfiles/rofi/theme.rasi            $HOME/.config/rofi/theme.rasi
ln -fs $HOME/Documents/Git/dotfiles/snippets/                  $HOME/.config/nvim/
ln -fs $HOME/Documents/Git/dotfiles/vim/en.utf-8.add           $HOME/.vim/en.utf-8.add
ln -fs $HOME/Documents/Git/dotfiles/termite/config             $HOME/.config/termite/config
ln -fs $HOME/Documents/Git/dotfiles/vim/vimrc                  $HOME/.config/nvim/init.vim
ln -fs $HOME/Documents/Git/dotfiles/vscode/settings.json       $HOME/.config/Code/User/settings.json
ln -fs $HOME/Documents/Git/dotfiles/vscode/keybindings.json    $HOME/.config/Code/User/keybindings.json
ln -fs $HOME/Documents/Git/dotfiles/zsh/zshrc                  $HOME/.zshrc
ln -fs $HOME/Documents/Git/dotfiles/zsh/zlogout                $HOME/.zlogout
ln -fs $HOME/Documents/Git/dotfiles/zsh/custom.zsh-theme       $HOME/.oh-my-zsh/themes/jayden-chan.zsh-theme
ln -fs $HOME/Documents/Git/dotfiles/firefox/MaterialFox/chrome $HOME/.mozilla/firefox/5zyahlda.default/
