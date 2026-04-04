local ts_config = require("config.treesitter_langs")
local plugins = require("config.plugins_list")

return {
	plugins.treesitter,
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		plugins.treesitter_textobjects,
	},
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})
		require("nvim-treesitter").install(ts_config.base)

		-- FIXME: this broke with nvim 0.12/new treesitter or whatever
		-- 	textobjects = {
		-- 		swap = {
		-- 			enable = true,
		-- 			swap_next = {
		-- 				["<leader>a"] = "@parameter.inner",
		-- 			},
		-- 			swap_previous = {
		-- 				["<leader>A"] = "@parameter.inner",
		-- 			},
		-- 		},

		vim.api.nvim_create_autocmd("FileType", {
			pattern = ts_config.extended,
			callback = function()
				vim.treesitter.start()
			end,
		})

		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

		local augroup = vim.api.nvim_create_augroup("TreesitterSpell", { clear = true })

		-- We can enable spell checking for any language that has
		-- treesitter since it will only check the comments and not the code
		vim.api.nvim_create_autocmd("FileType", {
			pattern = ts_config.extended,
			command = "setlocal spell spelllang=en_us",
			group = augroup,
		})
	end,
}
