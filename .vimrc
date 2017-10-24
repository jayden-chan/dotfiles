set nocompatible
filetype off

" Plugins

    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    Plugin 'VundleVim/Vundle.vim'
    Plugin 'scrooloose/nerdtree'
    Plugin 'easymotion/vim-easymotion'
    Plugin 'joshdick/onedark.vim'
    Plugin 'MarcWeber/vim-addon-mw-utils'
    Plugin 'tomtom/tlib_vim'
    Plugin 'garbas/vim-snipmate'
    Plugin 'arrufat/vala.vim'
    Plugin 'tpope/vim-surround'

    call vundle#end()
    filetype plugin indent on
    
" Behaviour

    syntax on
    colorscheme onedark

    set number relativenumber
    set expandtab
    set tabstop=4
    set shiftwidth=4
    set smarttab
    set smartindent

" Binds

    " Leader
    let mapleader = "\<Space>"

    " Anti-arthritis
    inoremap jj <Esc>

    " Reload .vimrc
    map <leader>ss :so $MYVIMRC<CR>

    " Map Ctrl-s to save because I am a compulsive saver 
    nmap <c-s> :w<CR>
    imap <c-s> <Esc>:w<CR>

    " Spell check
    map <F6> :setlocal spell! spelllang=en_ca<CR>

    " Delimiter auto complete
    inoremap {<CR> {<CR><BS>}<Esc>ko
    inoremap ( ()<Esc>i
    inoremap [ []<Esc>i

    " Remap cursor movement keys because I'm a scrub and don't use the default
    noremap h i
    noremap j h
    noremap k j
    noremap i k

    " Various other cursor control maps
    noremap L $
    noremap J 0
    noremap I H
    noremap K L

    " Disable Ex mode
    map q <nop>
    map Q <nop>

    " New line no insert mode
    map go o<Esc>

    " Tab switching
    map <tab>j :tabprevious<CR>
    map <tab>l :tabnext<CR>

" Plugin specific binds

    let NERDTreeMapOpenSplit='h'
    map <c-n> :NERDTreeToggle<CR>

" Abbreviations

    iab retrun return
    iab erturn return
    iab thsi this
    iab truel true;
    iab falsel false;
    iab returnl return;
