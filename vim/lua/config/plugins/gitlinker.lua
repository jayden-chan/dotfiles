local plugins = require("config.plugins_list")
return {
	plugins.gitlinker,
	lazy = true,
	init = function()
		vim.api.nvim_create_user_command("GOpen", function()
			require("gitlinker").get_buf_range_url("n")
		end, { range = true })
	end,
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
