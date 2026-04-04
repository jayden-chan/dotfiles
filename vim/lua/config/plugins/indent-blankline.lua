local plugins = require("config.plugins_list")
return {
	plugins.indent_blankline,
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		scope = { enabled = false },
	},
}
