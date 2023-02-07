local utils = require("config.utils")
return {
	utils.mirror("Comment.nvim"),
	dependencies = {
		utils.mirror("nvim-ts-context-commentstring"),
	},
	config = function()
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,
}
