local utils = require("config.utils")
return {
	"jayden-chan/base46.nvim",
	-- dir = "~/Dev/base46.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		LoadBase46ColorScheme(utils.theme.name)
	end,
}
