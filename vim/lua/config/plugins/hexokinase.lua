local utils = require("config.utils")
return {
	utils.mirror("vim-hexokinase"),
	build = "make hexokinase",
}
