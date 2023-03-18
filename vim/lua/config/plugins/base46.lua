local utils = require("config.utils")
return {
	utils.mirror("base46.nvim"),
	-- dir = "~/Dev/Personal/base46.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		LoadBase46ColorScheme(utils.theme.name)
	end,
}
