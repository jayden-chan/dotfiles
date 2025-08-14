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

local plugins = {
	"base46",
	"lualine",
	"tabular",
	"vim-surround",
	"lexima",
}

if os.getenv("NVIM_PASSAGE_MODE") ~= "true" then
	local other_plugins = {
		"indent-blankline",
		"neo-tree",
		"gitsigns",
		"vim-tmux-navigator",
		"vim-repeat",
		"comment",
		"fzf",
		"nvim-lspconfig",
		"none-ls",
		"fidget",
		"lspsaga",
		"trouble",
		"treesitter",
		"gitlinker",
		"luasnip",
		"blink-cmp",
		"vim-dadbod-ui",
		"todo-comments",
		"nvim-colorizer",
	}

	for _, item in ipairs(other_plugins) do
		table.insert(plugins, item)
	end
end

local plugins_configs = {}
for _, item in ipairs(plugins) do
	table.insert(plugins_configs, require("config.plugins." .. item))
end

require("lazy").setup(plugins_configs, {
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
