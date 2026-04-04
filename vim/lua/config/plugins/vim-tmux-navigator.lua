local plugins = require("config.plugins_list")
return {
	plugins.tmux_navigator,
	keys = {
		{ "<M-j>", "<cmd>TmuxNavigateLeft<cr>" },
		{ "<M-k>", "<cmd>TmuxNavigateDown<cr>" },
		{ "<M-i>", "<cmd>TmuxNavigateUp<cr>" },
		{ "<M-l>", "<cmd>TmuxNavigateRight<cr>" },
	},
}
