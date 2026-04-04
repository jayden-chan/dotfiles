local plugins = require("config.plugins_list")
return {
	plugins.ts_commentstring,
	config = function()
		require("ts_context_commentstring").setup({
			enable_autocmd = false,
		})

		local get_option = vim.filetype.get_option
		vim.filetype.get_option = function(filetype, option)
			return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
				or get_option(filetype, option)
		end
	end,
}
