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

cd $HOME
ln -fs $dots/picom/picom.conf        $config/picom.conf
ln -fs $dots/git/gitconfig           $HOME/.gitconfig
ln -fs $dots/latex/latexmkrc         $HOME/.latexmkrc
ln -fs $dots/rofi/theme.rasi         $config/rofi/theme.rasi
ln -fs $dots/snippets/               $config/nvim/
ln -fs $dots/vim/en.utf-8.add        $config/nvim/spell/en.utf-8.add
ln -fs $dots/vim/vimrc               $config/nvim/init.vim
ln -fs $dots/vscode/settings.json    $config/Code/User/settings.json
ln -fs $dots/vscode/keybindings.json $config/Code/User/keybindings.json
ln -fs $dots/zsh/zshrc               $HOME/.zshrc
ln -fs $dots/zsh/zlogout             $HOME/.zlogout
ln -fs $dots/awesome/theme.lua       $config/awesome/themes/rainbow/theme.lua
ln -fs $dots/awesome/rc.lua          $config/awesome/rc.lua
ln -fs $dots/kitty/kitty.conf        $config/kitty/kitty.conf
ln -fs $dots/starship/starship.toml  $config/starship.toml

if [ $(hostname) = "grace" ]; then
    ln -fs $dots/systemctl/hue.service $config/systemd/user/hue.service
fi

echo "Finished deployment, don't forget to copy udev rules into /etc/udev/rules.d/"
