local utils = require("config.utils")
return {
	utils.mirror("Comment.nvim"),
	dependencies = {
		utils.mirror("nvim-ts-context-commentstring"),
	},
	config = function()
		require("Comment").setup({
			mappings = {
				basic = false,
				extra = false,
			},
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,
	keys = {
		{
			"gcc",
			function()
				return vim.api.nvim_get_vvar("count") == 0 and "<Plug>(comment_toggle_linewise_current)"
					or "<Plug>(comment_toggle_linewise_count)"
			end,
			"n",
			expr = true,
			desc = "Comment toggle current line",
		},
		{
			"gc",
			"<Plug>(comment_toggle_linewise_visual)",
			mode = "x",
			desc = "Comment toggle linewise (visual)",
		},
	},
}
