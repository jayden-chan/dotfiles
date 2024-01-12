local utils = require("config.utils")
local ts_config = require("config.treesitter_langs")

return {
	utils.mirror("nvim-treesitter"),
	build = ":TSUpdate",
	ft = ts_config.extended,
	dependencies = {
		utils.mirror("nvim-treesitter-textobjects"),
		utils.mirror("playground"),
	},
	config = function()
		require("config.rust_sql")
		require("nvim-treesitter.configs").setup({
			ensure_installed = ts_config.base,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			incremental_selection = { enable = false },
			context_commentstring = {
				enable = true,
			},
			textobjects = {
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["hf"] = "@function.inner",
						["ab"] = "@block.outer",
						["hb"] = "@block.inner",
					},
				},
			},
		})

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
