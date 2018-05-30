rm $HOME/.tmux.conf        2>/dev/null
rm $HOME/.vimrc            2>/dev/null
rm $HOME/.zshrc            2>/dev/null
rm $HOME/.zlogout          2>/dev/null
rm $HOME/.vim/en.utf-8.add 2>/dev/null

ln -fs $HOME/Documents/Git/dotfiles/tmux/.tmux.conf  $HOME/.tmux.conf
ln -fs $HOME/Documents/Git/dotfiles/vim/vimrc        $HOME/.vimrc
ln -fs $HOME/Documents/Git/dotfiles/zsh/zshrc        $HOME/.zshrc
ln -fs $HOME/Documents/Git/dotfiles/zsh/zlogout      $HOME/.zlogout
ln -fs $HOME/Documents/Git/dotfiles/vim/en.utf-8.add $HOME/.vim/en.utf-8.add
ln -fs $HOME/Documents/Git/dotfiles/snippets/        $HOME/.vim/
