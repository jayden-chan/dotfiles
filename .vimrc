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

    call vundle#end()
    filetype plugin indent on
    
" Behaviour

    syntax on
    colorscheme onedark

    set expandtab
    set tabstop=4
    set shiftwidth=4
    set smarttab
    set smartindent
    
    set noshowmode

    let g:tex_flavor = "latex"

" Binds

    " Leader
    let mapleader = "\<Space>"

    " Relative line number toggle
    set number relativenumber
    map <F9> :set rnu!<CR>

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
    inoremap " ""<Esc>i
    inoremap ' ''<Esc>i

    " Easy semicolons
    inoremap ;; <Esc>$a;

    " Remap cursor movement keys because I'm a scrub and don't use the default
    noremap h i
    noremap j h
    noremap k j
    noremap i k

    " Various other cursor control maps
    noremap L $
    noremap J 0
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
    map q <nop>
    map Q <nop>

    " New line no insert mode
    map go o<Esc>

    " Copy Paste etc.
    map <leader>p "+p
    map <leader>y "+y

    " Tab switching
    map <tab>j :tabprevious<CR>
    map <tab>l :tabnext<CR>

" Plugin specific settings

    let NERDTreeMapOpenSplit='h'
    map <c-n> :NERDTreeToggle<CR>
    let g:airline_powerline_fonts = 1

" Abbreviations

    iab retrun return
    iab erturn return
    iab thsi this
    iab fcuntoin function
    iab fucntion function
