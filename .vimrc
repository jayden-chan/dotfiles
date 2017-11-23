set nocompatible

filetype off

" Plugins

    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    Plugin 'VundleVim/Vundle.vim'
    Plugin 'scrooloose/nerdtree'
    Plugin 'joshdick/onedark.vim'
    Plugin 'MarcWeber/vim-addon-mw-utils'
    Plugin 'tomtom/tlib_vim'
    Plugin 'garbas/vim-snipmate'
    Plugin 'arrufat/vala.vim'
    Plugin 'vim-airline/vim-airline'
    Plugin 'gcmt/taboo.vim'
    Plugin 'tpope/vim-fugitive'
    Plugin 'jiangmiao/auto-pairs'
    Plugin 'xuhdev/vim-latex-live-preview'

    call vundle#end()
    filetype plugin indent on
    
" Behaviour

    syntax on
    colorscheme onedark

    " Tab settings
    set expandtab
    set tabstop=4
    set shiftwidth=4
    set smarttab
    set smartindent

    " Search settings
    set gdefault
    set ignorecase
    set incsearch

    set splitright
    set lazyredraw

    " Nice line wraps
    set linebreak
    set breakindent

    " No auto folds please
    set foldlevel=1000
    set foldmethod=indent

    set undolevels=9001

    set cursorline
    
    set noshowmode
    set scrolloff=8

    set autochdir

    " Set .tex files to LaTeX syntax
    let g:tex_flavor = "latex"

    " Make LaTeX live preview smoother
    set updatetime=1000

" Binds

    " Leader
    let mapleader = "\<Space>"

    " Relative line number toggle
    set number relativenumber
    map <F9> <Esc>:set<Space>rnu!<CR>
    
    " Reload .vimrc
    map <leader>ss :so $MYVIMRC<CR>

    " Map Ctrl-s to save because I am a compulsive saver 
    nmap <c-s> :wa<CR>
    imap <c-s> <Esc>:wa<CR>

    " Spell check
    map <F6> :setlocal spell! spelllang=en_ca<CR>
    set spellfile=~/.vim/en.utf-8.add

    " ez semicolons
    inoremap ;; <Esc>$a;

    " Remap cursor movement keys because I'm a scrub and don't use the default
    noremap h i
    noremap j h
    noremap k gj
    noremap i gk

    " Various other cursor control maps
    noremap L $
    noremap J ^
    noremap I <c-u>
    noremap K <c-d>
    noremap <leader>z zz
    map <leader>j <C-w>h
    map <leader>k <C-w>j
    map <leader>i <C-w>k
    map <leader>l <C-w>l

    " Easily resize splits
    map <c-i> :resize -5<CR>
    map <c-k> :resize +5<CR>
    map <c-j> :vertical resize +5<CR>
    map <c-l> :vertical resize -5<CR>

    " Disable Ex mode
    map q: <nop>
    map Q <nop>

    " New line no insert mode
    map go o<Esc>

    " Easily open corresponding source file
    nmap <silent> <leader>vv :110vs ../src/%<.cpp \| tabn<CR>

    " Copy Paste etc.
    map <silent> <leader>p "+p
    map <silent> <leader>y "+y

    " Delete line without filling yank buffer
    nmap <silent> <leader>dd "_dd
    vmap <silent> <leader>dd "_dd

    " Tab switching
    map <tab>j :tabprevious<CR>
    map <tab>l :tabnext<CR>

" Plugin specific settings

    let NERDTreeMapOpenSplit='h'
    map <c-n> :NERDTreeToggle<CR>
    let g:snipMate = {}
    let g:snipMate.no_default_aliases = 1
    let g:airline_powerline_fonts = 1

    let g:livepreview_engine = 'xelatex'

" Abbreviations

    iab retrun return
    iab retnru return
    iab erturn return
    iab ertnru return
    iab thsi this
    iab fcuntoin function
    iab fucntion function
