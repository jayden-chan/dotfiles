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
	require("config.plugins.neo-tree"),
	require("config.plugins.gitsigns"),
	require("config.plugins.tabular"),
	require("config.plugins.vim-tmux-navigator"),
	require("config.plugins.vim-repeat"),
	require("config.plugins.comment"),
	require("config.plugins.vim-surround"),
	require("config.plugins.lexima"),
	require("config.plugins.fzf"),
	require("config.plugins.nvim-lspconfig"),
	require("config.plugins.none-ls"),
	require("config.plugins.fidget"),
	require("config.plugins.lspsaga"),
	require("config.plugins.trouble"),
	require("config.plugins.treesitter"),
	require("config.plugins.presence"),
	require("config.plugins.gitlinker"),
	require("config.plugins.luasnip"),
	require("config.plugins.blink-cmp"),
	require("config.plugins.vim-dadbod-ui"),
	require("config.plugins.todo-comments"),
	require("config.plugins.nvim-colorizer"),
}, {
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"zipPlugin",
				"tutor",
			},
		},
	},
})
