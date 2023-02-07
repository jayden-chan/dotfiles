local utils = require("config.utils")
return {
	utils.mirror("fidget.nvim"),
	config = function()
		require("fidget").setup()
	end,
}
