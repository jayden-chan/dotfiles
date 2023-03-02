local utils = require("config.utils")
return {
	utils.mirror("base46.nvim"),
	-- dir = "~/Dev/Personal/base46.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local present, base46 = pcall(require, "base46")
		if not present then
			return
		end
		local theme_opts = {
			base = utils.theme.color_base,
			theme = utils.theme.theme,
			transparency = false,
		}
		base46.load_theme(theme_opts)
	end,
}
