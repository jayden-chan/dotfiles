local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system(
        { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    )
end

require('packer').startup(function(use)
    local function mirror(name)
        return 'https://git.jayden.codes/mirrors/' .. name
    end

    -- Use Packer itself
    use(mirror('packer.nvim'))

    -- Theme
    use(mirror('indent-blankline.nvim'))
    use(mirror('lualine.nvim'))
    use(mirror('base46.nvim'))

    -- fs nav
    use(mirror('plenary.nvim'))
    use(mirror('neogit'))
    use(mirror('telescope.nvim'))
    use(mirror('nvim-web-devicons'))
    use(mirror('nvim-tree.lua'))

    -- Git
    use(mirror('gitsigns.nvim'))
    use(mirror('vim-fugitive'))
    use(mirror('vim-rhubarb'))

    -- Misc
    use(mirror('tabular'))
    use(mirror('editorconfig-vim'))
    use(mirror('vim-tmux-navigator'))
    use(mirror('presence.nvim'))
    use(mirror('undotree'))
    use(mirror('vim-repeat'))

    -- IDE-like
    use(mirror('nvim-lspconfig'))
    use(mirror('cmp-nvim-lsp'))
    use(mirror('cmp-buffer'))
    use(mirror('cmp-git'))
    use(mirror('cmp-path'))
    use(mirror('cmp-cmdline'))
    use(mirror('nvim-cmp'))
    use(mirror('cmp-nvim-ultisnips'))
    use(mirror('lspkind-nvim'))
    use(mirror('telescope-ui-select.nvim'))

    use(mirror('nvim-autopairs'))
    use(mirror('Comment.nvim'))
    use(mirror('vim-surround'))
    use(mirror('ultisnips'))

    -- Syntax
    use {
        { mirror('nvim-treesitter'), run = ':TSUpdate' },
        { mirror('nvim-treesitter-textobjects') },
        { mirror('spellsitter.nvim') },
        { mirror('nvim-gps') },
    }
    use { mirror('vim-markdown'), ft = { 'markdown' } }
    use { mirror('pgsql.vim'), ft = { 'psql' } }
    use { mirror('timing-diagram-generator'), branch = 'vim-plugin' }
    use { mirror('rust.vim'), ft = { 'rust' } }
    use { mirror('vim-sxhkdrc') }
    use { mirror('vim-hexokinase'), run = 'make hexokinase' }
    use { mirror('nginx.vim'), ft = { 'nginx' } }

    if packer_bootstrap then
        require('packer').sync()
    end
end)
