local utils = require("config.utils")
return {
	utils.mirror("neogit"),
	opts = {
		disable_commit_confirmation = true,
		commit_popup = {
			kind = "vsplit",
		},
	},
	keys = {
		{ "<leader>N", '<cmd>lua require("neogit").open({ kind = "replace" })<cr>' },
	},
}
