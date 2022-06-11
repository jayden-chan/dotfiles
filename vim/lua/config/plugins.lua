local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system(
    {'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path}
    )
end

require('packer').startup(function()
    -- Use Packer itself
    use 'wbthomason/packer.nvim'

    -- Theme
    use 'lukas-reineke/indent-blankline.nvim'
    use 'nvim-lualine/lualine.nvim'
    use '~/Dev/Personal/base46.nvim'

    -- fs nav
    use 'nvim-lua/plenary.nvim'
    use 'TimUntersberger/neogit'
    use 'nvim-telescope/telescope.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'kyazdani42/nvim-tree.lua'

    -- Git
    use 'lewis6991/gitsigns.nvim'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'

    -- Misc
    use 'godlygeek/tabular'
    use 'editorconfig/editorconfig-vim'
    use 'christoomey/vim-tmux-navigator'
    use 'andweeb/presence.nvim'
    use 'mbbill/undotree'
    use 'tpope/vim-repeat'

    -- IDE-like
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-git'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'quangnguyen30192/cmp-nvim-ultisnips'
    use 'onsails/lspkind-nvim'

    use 'windwp/nvim-autopairs'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'SirVer/ultisnips'

    -- Syntax
    use {
        {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'},
        {'nvim-treesitter/nvim-treesitter-textobjects'},
        {'lewis6991/spellsitter.nvim'},
        {'SmiteshP/nvim-gps'},
    }
    use {'plasticboy/vim-markdown', ft={'markdown'}}
    use {'lifepillar/pgsql.vim', ft = {'psql'}}
    use {'jayden-chan/timing-diagram-generator', branch = 'vim-plugin'}
    use {'jayden-chan/rust.vim', ft = {'rust'}}
    use {'baskerville/vim-sxhkdrc'}
    use {'rrethy/vim-hexokinase', run = 'make hexokinase'}
    use {'chr4/nginx.vim', ft = {'nginx'}}

    if packer_bootstrap then
        require('packer').sync()
    end
end)
