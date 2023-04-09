local utils = require("config.utils")
return {
	utils.mirror("leap.nvim"),
	config = function()
		require("leap").add_default_mappings()
	end,
}
