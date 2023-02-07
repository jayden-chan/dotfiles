local utils = require("config.utils")
return {
	utils.mirror("lspsaga.nvim"),
	opts = {
		ui = {
			-- code_action = ""
		},
		finder = {
			edit = { "o", "<CR>" },
			quit = { "q", "<ESC>" },
			split = "H",
			tabe = "t",
			vsplit = "s",
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
