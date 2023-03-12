local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require("config.plugins.base46"),
	require("config.plugins.indent-blankline"),
	require("config.plugins.lualine"),
	require("config.plugins.plenary"),
	require("config.plugins.nvim-web-devicons"),
	require("config.plugins.nui"),
	require("config.plugins.neo-tree"),
	require("config.plugins.gitsigns"),
	require("config.plugins.vim-fugitive"),
	require("config.plugins.tabular"),
	require("config.plugins.vim-tmux-navigator"),
	require("config.plugins.vim-repeat"),
	require("config.plugins.comment"),
	require("config.plugins.nvim-ts-context-commentstring"),
	require("config.plugins.vim-surround"),
	require("config.plugins.lexima"),
	require("config.plugins.telescope"),
	require("config.plugins.cmp-nvim-lsp"),
	require("config.plugins.cmp-buffer"),
	require("config.plugins.cmp-git"),
	require("config.plugins.cmp-path"),
	require("config.plugins.cmp-cmdline"),
	require("config.plugins.lspkind-nvim"),
	require("config.plugins.nvim-cmp"),
	require("config.plugins.nvim-lspconfig"),
	require("config.plugins.null-ls"),
	require("config.plugins.fidget"),
	require("config.plugins.lspsaga"),
	require("config.plugins.trouble"),
	require("config.plugins.nvim-treesitter-textobjects"),
	require("config.plugins.spellsitter"),
	require("config.plugins.treesitter"),
	require("config.plugins.treesitter-playground"),
	require("config.plugins.tdg"),
	require("config.plugins.hexokinase"),
	require("config.plugins.nginx"),
	require("config.plugins.presence"),
	require("config.plugins.gitlinker"),
	require("config.plugins.vim-helm"),
	require("config.plugins.luasnip"),
})
