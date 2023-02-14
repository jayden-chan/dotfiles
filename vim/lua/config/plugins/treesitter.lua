local utils = require("config.utils")
local treesitter_langs = require("config.treesitter_langs")

return {
	utils.mirror("nvim-treesitter"),
	build = ":TSUpdate",
	ft = treesitter_langs,
	dependencies = {
		utils.mirror("nvim-treesitter-textobjects"),
		utils.mirror("spellsitter.nvim"),
		utils.mirror("playground"),
	},
	config = function()
		require("config.rust_sql")
		require("nvim-treesitter.configs").setup({
			ensure_installed = treesitter_langs,
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

		require("spellsitter").setup()

		-- We can enable spell checking for any language that has
		-- treesitter since it will only check the comments and not the code
		for _, v in ipairs(treesitter_langs) do
			vim.cmd("autocmd FileType " .. v .. " setlocal spell spelllang=en_us")
		end
	end,
}
