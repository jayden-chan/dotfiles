#!/bin/sh

rm -rf $HOME/.config/picom.conf   2>/dev/null
rm -rf $HOME/.config/rofi         2>/dev/null
rm -rf $HOME/.config/nvim         2>/dev/null
rm -rf $HOME/.vim                 2>/dev/null
rm -rf $HOME/.config/kitty        2>/dev/null

mkdir -p $HOME/.config/nvim/colors
mkdir -p $HOME/.config/nvim/spell
mkdir -p $HOME/.config/rofi
mkdir -p $HOME/.config/kitty

cd $HOME
ln -fs $HOME/Documents/Git/dotfiles/picom/picom.conf        $HOME/.config/picom.conf
ln -fs $HOME/Documents/Git/dotfiles/git/gitconfig           $HOME/.gitconfig
ln -fs $HOME/Documents/Git/dotfiles/latex/latexmkrc         $HOME/.latexmkrc
ln -fs $HOME/Documents/Git/dotfiles/rofi/theme.rasi         $HOME/.config/rofi/theme.rasi
ln -fs $HOME/Documents/Git/dotfiles/snippets/               $HOME/.config/nvim/
ln -fs $HOME/Documents/Git/dotfiles/vim/en.utf-8.add        $HOME/.config/nvim/spell/en.utf-8.add
ln -fs $HOME/Documents/Git/dotfiles/vim/vimrc               $HOME/.config/nvim/init.vim
ln -fs $HOME/Documents/Git/dotfiles/vscode/settings.json    $HOME/.config/Code/User/settings.json
ln -fs $HOME/Documents/Git/dotfiles/vscode/keybindings.json $HOME/.config/Code/User/keybindings.json
ln -fs $HOME/Documents/Git/dotfiles/zsh/zshrc               $HOME/.zshrc
ln -fs $HOME/Documents/Git/dotfiles/zsh/zlogout             $HOME/.zlogout
ln -fs $HOME/Documents/Git/dotfiles/awesome/theme.lua       $HOME/.config/awesome/themes/rainbow/theme.lua
ln -fs $HOME/Documents/Git/dotfiles/awesome/rc.lua          $HOME/.config/awesome/rc.lua
ln -fs $HOME/Documents/Git/dotfiles/kitty/kitty.conf        $HOME/.config/kitty/kitty.conf
ln -fs $HOME/Documents/Git/dotfiles/starship/starship.toml  $HOME/.config/starship.toml
