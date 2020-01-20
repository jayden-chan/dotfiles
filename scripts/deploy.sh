#!/bin/sh

rm -rf $HOME/.config/compton.conf 2>/dev/null
rm -rf $HOME/.config/dunst        2>/dev/null
rm -rf $HOME/.config/i3           2>/dev/null
rm -rf $HOME/.config/polybar      2>/dev/null
rm -rf $HOME/.config/rofi         2>/dev/null
rm -rf $HOME/.config/nvim         2>/dev/null
rm -rf $HOME/.vim                 2>/dev/null
rm -rf $HOME/.config/alacritty    2>/dev/null
rm -rf $HOME/.config/kitty        2>/dev/null

mkdir -p $HOME/.vim
mkdir -p $HOME/.config/nvim/colors
mkdir -p $HOME/.config/compton
mkdir -p $HOME/.config/dunst
mkdir -p $HOME/.config/i3
mkdir -p $HOME/.config/polybar
mkdir -p $HOME/.config/rofi
mkdir -p $HOME/.config/alacritty
mkdir -p $HOME/.config/kitty

cd $HOME
ln -fs $HOME/Documents/Git/dotfiles/compton/compton.conf    $HOME/.config/compton.conf
ln -fs $HOME/Documents/Git/dotfiles/dunst/dunstrc           $HOME/.config/dunst/dunstrc
ln -fs $HOME/Documents/Git/dotfiles/git/gitconfig           $HOME/.gitconfig
ln -fs $HOME/Documents/Git/dotfiles/i3/config               $HOME/.config/i3/config
ln -fs $HOME/Documents/Git/dotfiles/latex/latexmkrc         $HOME/.latexmkrc
ln -fs $HOME/Documents/Git/dotfiles/polybar/config          $HOME/.config/polybar/config
ln -fs $HOME/Documents/Git/dotfiles/rofi/theme.rasi         $HOME/.config/rofi/theme.rasi
ln -fs $HOME/Documents/Git/dotfiles/snippets/               $HOME/.config/nvim/
ln -fs $HOME/Documents/Git/dotfiles/vim/en.utf-8.add        $HOME/.vim/en.utf-8.add
ln -fs $HOME/Documents/Git/dotfiles/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
ln -fs $HOME/Documents/Git/dotfiles/vim/vimrc               $HOME/.config/nvim/init.vim
ln -fs $HOME/Documents/Git/dotfiles/vscode/settings.json    $HOME/.config/Code/User/settings.json
ln -fs $HOME/Documents/Git/dotfiles/vscode/keybindings.json $HOME/.config/Code/User/keybindings.json
ln -fs $HOME/Documents/Git/dotfiles/zsh/zshrc               $HOME/.zshrc
ln -fs $HOME/Documents/Git/dotfiles/zsh/zlogout             $HOME/.zlogout
ln -fs $HOME/Documents/Git/dotfiles/awesome/theme.lua       $HOME/.config/awesome/themes/rainbow/theme.lua
ln -fs $HOME/Documents/Git/dotfiles/awesome/rc.lua          $HOME/.config/awesome/rc.lua
ln -fs $HOME/Documents/Git/dotfiles/kitty/kitty.conf        $HOME/.config/kitty/kitty.conf
