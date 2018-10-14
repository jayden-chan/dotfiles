# Bootstrapping a new Vim installation

**Warning: This vimrc requires Neovim**

Most of the stuff in there will work with Vim 8+ but some of it will not. I make no guarantees if you are not using Neovim.

## Dependencies
* [Go](https://golang.org/dl/)
* [gotests](https://github.com/cweill/gotests)
* Git

## Install Vundle
[GitHub page](https://github.com/VundleVim/Vundle.vim)

Install:
```sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

## Clone repository
```sh
git clone https://github.com/jayden-chan/dotfiles <FULL_REPO_DIR>
```

## Symlink .vimrc
```sh
ln -fs <FULL_REPO_DIR>/vim/vimrc $HOME/.config/nvim/init.vim
```

### (Optional) Symlink snippets
```sh
ln -fs <FULL_REPO_DIR>/snippets/ $HOME/.config/nvim/
```

## Install Plugins
* Start vim with `nvim`
* Run: `:PluginInstall`
