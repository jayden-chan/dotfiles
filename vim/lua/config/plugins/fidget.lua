local utils = require("config.utils")
return {
	utils.mirror("fidget.nvim"),
	event = "VeryLazy",
	config = function()
		require("fidget").setup()
	end,
}
