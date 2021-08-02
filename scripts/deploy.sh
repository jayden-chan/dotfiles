#!/usr/bin/dash

dots=$HOME/Documents/Git/dotfiles
config=$HOME/.config

rm -rf $config/rofi    2>/dev/null
rm -rf $config/nvim    2>/dev/null
rm -rf $config/latexmk 2>/dev/null
rm -rf $config/tmux    2>/dev/null
rm -rf $config/bspwm   2>/dev/null
rm -rf $config/sxhkd   2>/dev/null
rm -rf $config/zsh     2>/dev/null
rm -rf $config/npm     2>/dev/null
rm -rf $config/polybar 2>/dev/null
rm -rf $config/dunst   2>/dev/null

mkdir -p $config/rofi
mkdir -p $config/nvim/colors
mkdir -p $config/nvim/spell
mkdir -p $config/latexmk
mkdir -p $config/tmux
mkdir -p $config/bspwm
mkdir -p $config/sxhkd
mkdir -p $config/zsh
mkdir -p $config/git
mkdir -p $config/npm
mkdir -p $config/awesome
mkdir -p $config/polybar
mkdir -p $config/dunst

mkdir -p $HOME/.local/share/fonts
mkdir -p $HOME/.local/bin

if [ "$1" = "--full" ]; then
    echo "Installing vim-plugged"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    echo "Installing awesome themes"
    git clone --recursive https://github.com/lcpz/awesome-copycats.git
    mv -bv awesome-copycats/* ~/.config/awesome && rm -rf awesome-copycats

    echo "Installing awesome battery widget"
    if [ "$(hostname)" = "grace" ]; then
        echo "Desktop detected, not installing battery widget"
    else
        git clone https://github.com/deficient/battery-widget.git ~/.config/awesome/battery-widget
    fi
fi

cd $HOME
ln -fs $dots/awesome/awesome.png     $config/awesome/themes/rainbow/icons/awesome.png
ln -fs $dots/awesome/rc.lua          $config/awesome/rc.lua
ln -fs $dots/awesome/theme.lua       $config/awesome/themes/rainbow/theme.lua
ln -fs $dots/git/gitconfig           $config/git/config
ln -fs $dots/latex/latexmkrc         $config/latexmk/latexmkrc
ln -fs $dots/picom/picom.conf        $config/picom.conf
ln -fs $dots/rofi/theme.rasi         $config/rofi/default.rasi
ln -fs $dots/scripts/p.js            $HOME/.local/bin/p
ln -fs $dots/snippets/               $config/nvim/UltiSnips
ln -fs $dots/starship/starship.toml  $config/starship.toml
ln -fs $dots/tmux/tmux.conf          $config/tmux/tmux.conf
ln -fs $dots/vim/en.utf-8.add        $config/nvim/spell/en.utf-8.add
ln -fs $dots/vim/vimrc               $config/nvim/init.vim
ln -fs $dots/vim/coc-settings.json   $config/nvim/coc-settings.json
ln -fs $dots/zsh/zlogout             $config/zsh/.zlogout
ln -fs $dots/zsh/zshrc               $config/zsh/.zshrc
ln -fs $dots/zsh/zshenv              $HOME/.zshenv
ln -fs $dots/npm/npmrc               $config/npm/npmrc
ln -fs $dots/bspwm/bspwmrc           $config/bspwm/bspwmrc
ln -fs $dots/bspwm/sxhkdrc           $config/bspwm/sxhkdrc
ln -fs $dots/polybar/config          $config/polybar/config
ln -fs $dots/dunst/dunstrc           $config/dunst/dunstrc

cp $dots/font/JetBrains_Mono_Regular_Nerd_Font_Complete_Mono.ttf ~/.local/share/fonts/
sudo fc-cache -fv

echo "Finished deployment"
