---            ---
--- Treesitter ---
---            ---
local treesitter_langs = {
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"dockerfile",
	"go",
	"graphql",
	"java",
	"javascript",
	"jsonc",
	"latex",
	"lua",
	"make",
	"python",
	"query",
	"rasi",
	"rust",
	"sql",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"yaml",
}

require("nvim-treesitter.configs").setup({
	ensure_installed = treesitter_langs,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true },
	incremental_selection = { enable = false },
})
require("spellsitter").setup()

-- We can enable spell checking for any language that has
-- treesitter since it will only check the comments and not the code
for _, v in ipairs(treesitter_langs) do
	vim.cmd("autocmd FileType " .. v .. " setlocal spell spelllang=en_us")
end

require("nvim-treesitter.configs").setup({
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
