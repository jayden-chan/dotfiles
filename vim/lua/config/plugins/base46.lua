local utils = require("config.utils")
local plugins = require("config.plugins_list")
return {
	plugins.base46,
	-- dir = "~/Dev/base46.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		LoadBase46ColorScheme(utils.theme.name)
	end,
}
