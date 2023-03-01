local utils = require("config.utils")
return {
	utils.mirror("gitlinker.nvim"),
	lazy = true,
	init = function()
		vim.api.nvim_create_user_command("GOpen", function(opts)
			require("gitlinker").get_buf_range_url("n")
		end, { range = true })
	end,
	dependencies = { utils.mirror("plenary.nvim") },
	config = function()
		require("gitlinker").setup({
			mappings = nil,
			opts = {
				action_callback = require("gitlinker.actions").open_in_browser,
			},
			callbacks = {
				["git.jayden.codes"] = require("gitlinker.hosts").get_gitea_type_url,
			},
		})
	end,
}
