rm $HOME/.tmux.conf        2>/dev/null
rm $HOME/.vimrc            2>/dev/null
rm $HOME/.zshrc            2>/dev/null
rm $HOME/.zlogout          2>/dev/null
rm $HOME/.gitconfig        2>/dev/null
rm -rf $HOME/.vim/         2>/dev/null

mkdir  $HOME/.vim
ln -fs $HOME/Documents/Git/dotfiles/tmux/.tmux.conf  $HOME/.tmux.conf
ln -fs $HOME/Documents/Git/dotfiles/vim/vimrc        $HOME/.vimrc
ln -fs $HOME/Documents/Git/dotfiles/zsh/zshrc        $HOME/.zshrc
ln -fs $HOME/Documents/Git/dotfiles/zsh/zlogout      $HOME/.zlogout
ln -fs $HOME/Documents/Git/dotfiles/vim/en.utf-8.add $HOME/.vim/en.utf-8.add
ln -fs $HOME/Documents/Git/dotfiles/snippets/        $HOME/.vim/
ln -fs $HOME/Documents/Git/dotfiles/git/gitconfig    $HOME/.gitconfig

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
