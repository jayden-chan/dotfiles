local plugins = require("config.plugins_list")
return {
	plugins.fidget,
	event = "VeryLazy",
	config = function()
		require("fidget").setup()
	end,
}
