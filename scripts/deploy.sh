#!/bin/sh

rm -r /home/jayden/.config/compton.conf 2>/dev/null
rm -r /home/jayden/.config/dunst        2>/dev/null
rm -r /home/jayden/.config/i3           2>/dev/null
rm -r /home/jayden/.config/polybar      2>/dev/null
rm -r /home/jayden/.config/rofi         2>/dev/null
rm -r /home/jayden/.config/nvim         2>/dev/null
rm -r /home/jayden/.vim                 2>/dev/null
rm -r /home/jayden/.config/termite      2>/dev/null

mkdir -p /home/jayden/.vim
mkdir -p /home/jayden/.config/nvim
mkdir -p /home/jayden/.config/compton
mkdir -p /home/jayden/.config/dunst
mkdir -p /home/jayden/.config/i3
mkdir -p /home/jayden/.config/polybar
mkdir -p /home/jayden/.config/rofi
mkdir -p /home/jayden/.config/termite

ln -fs /home/jayden/Documents/Git/dotfiles/compton/compton.conf /home/jayden/.config/compton.conf
ln -fs /home/jayden/Documents/Git/dotfiles/dunst/dunstrc        /home/jayden/.config/dunst/dunstrc
ln -fs /home/jayden/Documents/Git/dotfiles/git/gitconfig        /home/jayden/.gitconfig
ln -fs /home/jayden/Documents/Git/dotfiles/i3/config            /home/jayden/.config/i3/config
ln -fs /home/jayden/Documents/Git/dotfiles/latex/latexmkrc      /home/jayden/.latexmkrc
ln -fs /home/jayden/Documents/Git/dotfiles/polybar/config       /home/jayden/.config/polybar/config
ln -fs /home/jayden/Documents/Git/dotfiles/rofi/theme.rasi      /home/jayden/.config/rofi/theme.rasi
ln -fs /home/jayden/Documents/Git/dotfiles/snippets/            /home/jayden/.vim/
ln -fs /home/jayden/Documents/Git/dotfiles/snippets/            /home/jayden/.config/nvim/
ln -fs /home/jayden/Documents/Git/dotfiles/vim/en.utf-8.add     /home/jayden/.vim/en.utf-8.add
ln -fs /home/jayden/Documents/Git/dotfiles/termite/config       /home/jayden/.config/termite/config
ln -fs /home/jayden/Documents/Git/dotfiles/vim/vimrc            /home/jayden/.config/nvim/init.vim
ln -fs /home/jayden/Documents/Git/dotfiles/zsh/zshrc            /home/jayden/.zshrc
ln -fs /home/jayden/Documents/Git/dotfiles/zsh/zlogout          /home/jayden/.zlogout
ln -fs /home/jayden/Documents/Git/dotfiles/zsh/custom.zsh-theme /home/jayden/.oh-my-zsh/themes/jayden-chan.zsh-theme
