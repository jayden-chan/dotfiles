#!/usr/bin/dash

dots=$HOME/Documents/Git/dotfiles
config=$HOME/.config

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
ln -fs $dots/bspwm/bspwmrc           $config/bspwm/bspwmrc
ln -fs $dots/git/gitconfig           $config/git/config
ln -fs $dots/latex/latexmkrc         $config/latexmk/latexmkrc
ln -fs $dots/npm/npmrc               $config/npm/npmrc
ln -fs $dots/rofi/theme.rasi         $config/rofi/default.rasi
ln -fs $dots/snippets/               $config/nvim/UltiSnips
ln -fs $dots/starship/starship.toml  $config/starship.toml
ln -fs $dots/tmux/tmux.conf          $config/tmux/tmux.conf
ln -fs $dots/vim/coc-settings.json   $config/nvim/coc-settings.json
ln -fs $dots/vim/vimrc               $config/nvim/init.vim
ln -fs $dots/zsh/zlogout             $config/zsh/.zlogout
ln -fs $dots/zsh/zshrc               $config/zsh/.zshrc
ln -fs $dots/zsh/zshenv              $HOME/.zshenv
ln -fs $dots/scripts/p.js            $HOME/.local/bin/p

cp $dots/font/JetBrains_Mono_Regular_Nerd_Font_Complete_Mono.ttf ~/.local/share/fonts/
sudo fc-cache -fv

echo "Finished deployment"
