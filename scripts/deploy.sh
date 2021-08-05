#!/usr/bin/dash

dots=$HOME/Documents/Git/dotfiles
config=$HOME/.config

if [ "$1" = "--env" ]; then
    ln -fs $dots/zsh/zshenv $config/zsh/.zshenv
    ln -fs $dots/zsh/zshenv $HOME/.xprofile
    exit
fi

rm -rf $config/bspwm   2>/dev/null
rm -rf $config/latexmk 2>/dev/null
rm -rf $config/npm     2>/dev/null
rm -rf $config/nvim    2>/dev/null
rm -rf $config/rofi    2>/dev/null
rm -rf $config/tmux    2>/dev/null
rm -rf $config/zsh     2>/dev/null

mkdir -p $config/bspwm
mkdir -p $config/git
mkdir -p $config/latexmk
mkdir -p $config/npm
mkdir -p $config/nvim/colors
mkdir -p $config/rofi
mkdir -p $config/tmux
mkdir -p $config/zsh

mkdir -p $HOME/.local/share/fonts
mkdir -p $HOME/.local/bin

cd $HOME
ln -fs $dots/bspwm/bspwmrc          $config/bspwm/
ln -fs $dots/git/gitconfig          $config/git/config
ln -fs $dots/misc/latexmkrc         $config/latexmk/
ln -fs $dots/rofi/base.rasi         $config/rofi/
ln -fs $dots/rofi/drun.rasi         $config/rofi/
ln -fs $dots/rofi/power.rasi        $config/rofi/
ln -fs $dots/snippets/              $config/nvim/UltiSnips
ln -fs $dots/misc/starship.toml     $config/
ln -fs $dots/misc/tmux.conf         $config/tmux/
ln -fs $dots/vim/coc-settings.json  $config/nvim/
ln -fs $dots/vim/vimrc              $config/nvim/init.vim
ln -fs $dots/zsh/zlogout            $config/zsh/.zlogout
ln -fs $dots/zsh/zshrc              $config/zsh/.zshrc
ln -fs $dots/scripts/p.js           $HOME/.local/bin/p

cp $dots/misc/npmrc                 $config/npm/

cp $dots/font/JetBrains_Mono_Regular_Nerd_Font_Complete_Mono.ttf ~/.local/share/fonts/
sudo fc-cache -fv

echo
echo "Finished deployment"
