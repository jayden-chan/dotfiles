local plugins = require("config.plugins_list")
return {
	plugins.vim_surround,
	event = "VeryLazy",
}
