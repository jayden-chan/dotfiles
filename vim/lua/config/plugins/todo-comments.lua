local plugins = require("config.plugins_list")
return {
	plugins.todo_comments,
	dependencies = { plugins.plenary },
	opts = {},
}
