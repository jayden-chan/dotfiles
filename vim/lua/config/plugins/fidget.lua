local utils = require("config.utils")
return {
	utils.mirror("fidget.nvim"),
	tag = "legacy",
	event = "VeryLazy",
	config = function()
		require("fidget").setup()
	end,
}
