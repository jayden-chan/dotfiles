local utils = require("config.utils")
return {
	utils.mirror("indent-blankline.nvim"),
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		scope = { enabled = false },
	},
}
