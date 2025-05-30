local utils = require("config.utils")
return {
	utils.mirror("blame.nvim"),
	lazy = false,
	opts = {
		date_format = "%Y-%m-%d",
		mappings = {
			commit_info = "o",
			stack_push = "<TAB>",
			stack_pop = "<BS>",
			show_commit = "<CR>",
			close = { "<esc>", "q" },
		},
	},
}
