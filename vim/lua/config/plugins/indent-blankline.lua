local utils = require("config.utils")
return {
	utils.mirror("indent-blankline.nvim"),
	opts = {
		show_current_context = false,
		show_current_context_start = false,
	},
}
