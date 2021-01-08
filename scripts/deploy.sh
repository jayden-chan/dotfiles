#!/bin/sh

dots=$HOME/Documents/Git/dotfiles
config=$HOME/.config

rm -rf $config/rofi       2>/dev/null
rm -rf $config/nvim       2>/dev/null
rm -rf $config/kitty      2>/dev/null
rm -rf $config/systemd    2>/dev/null

mkdir -p $config/rofi
mkdir -p $config/nvim/colors
mkdir -p $config/nvim/spell
mkdir -p $config/kitty
mkdir -p $config/systemd/user
mkdir -p $config/awesome

echo "Installing vim-plugged"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "Installing awesome themes"
git clone --recursive https://github.com/lcpz/awesome-copycats.git
mv -bv awesome-copycats/* ~/.config/awesome && rm -rf awesome-copycats

echo "Installing awesome battery widget"
if [ $(hostname) = "grace" ]; then
    echo "Desktop detected, not installing battery widget"
else
    git clone https://github.com/deficient/battery-widget.git ~/.config/awesome/battery-widget
fi

cd $HOME
ln -fs $dots/git/gitconfig             $HOME/.gitconfig
ln -fs $dots/latex/latexmkrc           $HOME/.latexmkrc
ln -fs $dots/zsh/zshrc                 $HOME/.zshrc
ln -fs $dots/zsh/zlogout               $HOME/.zlogout
ln -fs $dots/tmux/tmux.conf            $HOME/.tmux.conf
ln -fs $dots/rofi/theme.rasi           $config/rofi/theme.rasi
ln -fs $dots/snippets/                 $config/nvim/UltiSnips/
ln -fs $dots/vim/en.utf-8.add          $config/nvim/spell/en.utf-8.add
ln -fs $dots/vim/vimrc                 $config/nvim/init.vim
ln -fs $dots/vscode/settings.json      $config/Code/User/settings.json
ln -fs $dots/vscode/keybindings.json   $config/Code/User/keybindings.json
ln -fs $dots/awesome/theme.lua         $config/awesome/themes/rainbow/theme.lua
ln -fs $dots/awesome/awesome.png       $config/awesome/themes/rainbow/icons/awesome.png
ln -fs $dots/awesome/rc.lua            $config/awesome/rc.lua
ln -fs $dots/picom/picom.conf          $config/picom.conf
ln -fs $dots/starship/starship.toml    $config/starship.toml
ln -fs $dots/termite/config            $config/termite/config

echo "Finished deployment"
