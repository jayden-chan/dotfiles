local utils = require("config.utils")
return {
	utils.mirror("lspsaga.nvim"),
	lazy = true,
	opts = {
		finder = {
			edit = { "o", "<CR>" },
			quit = { "q", "<ESC>" },
			split = "H",
			tabe = "t",
			vsplit = "s",
		},
		hover = {
			max_width = 0.6,
		},
		lightbulb = {
			enable = true,
			enable_in_insert = false,
			cache_code_action = false,
			sign = true,
			update_time = 150,
			sign_priority = 20,
			virtual_text = true,
		},
	},
}
