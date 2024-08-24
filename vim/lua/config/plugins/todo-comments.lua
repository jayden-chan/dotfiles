local utils = require("config.utils")
return {
	utils.mirror("todo-comments.nvim"),
	dependencies = { utils.mirror("plenary.nvim") },
	opts = {},
}
