local utils = require("config.utils")
return {
	utils.mirror("vim-hexokinase"),
	event = "VeryLazy",
	build = "make hexokinase",
}
