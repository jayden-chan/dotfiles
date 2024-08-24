local utils = require("config.utils")
return {
	utils.mirror("vim-dadbod-ui"),
	dependencies = {
		{ utils.mirror("vim-dadbod"), lazy = true },
		{ utils.mirror("vim-dadbod-completion"), lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
	end,
}
