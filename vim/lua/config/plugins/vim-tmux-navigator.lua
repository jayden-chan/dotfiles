local utils = require("config.utils")
return {
	utils.mirror("vim-tmux-navigator"),
	keys = {
		{ "<M-j>", "<cmd>TmuxNavigateLeft<cr>" },
		{ "<M-k>", "<cmd>TmuxNavigateDown<cr>" },
		{ "<M-i>", "<cmd>TmuxNavigateUp<cr>" },
		{ "<M-l>", "<cmd>TmuxNavigateRight<cr>" },
	},
}
