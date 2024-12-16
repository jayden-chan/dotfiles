local utils = require("config.utils")
return {
	utils.mirror("nvim-colorizer.lua"),
	event = "BufReadPre",
	opts = {
		user_default_options = {
			mode = "virtualtext",
			names = false,
		},
	},
}
