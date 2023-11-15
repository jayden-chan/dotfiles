local utils = require("config.utils")
return {
	utils.mirror("indent-blankline.nvim"),
	main = "ibl",
	opts = {
		scope = { enabled = false },
	},
}
