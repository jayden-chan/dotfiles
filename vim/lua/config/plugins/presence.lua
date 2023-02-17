local utils = require("config.utils")
return {
	utils.mirror("presence.nvim"),
	cond = function()
		local git_root = vim.fn.finddir(".git", ".;")
		if git_root ~= "" then
			local lines = vim.fn.readfile(git_root .. "/config")
			for _, l in pairs(lines) do
				local line = l:gsub("%s+", "")
				if string.find(line, "shouldenablepresencenvim") and not string.find(line, ";") then
					return true
				end
			end
		end
		return false
	end,
	opts = {
		auto_update = true,
		neovim_image_text = "The One True Text Editor",
		main_image = "neovim",
		client_id = "793271441293967371",
		log_level = nil,
		debounce_timeout = 10,
		enable_line_number = false,
		blacklist = {},
		buttons = false,
		file_assets = {},
		show_time = true,

		editing_text = "Editing %s",
		file_explorer_text = "Browsing %s",
		git_commit_text = "Committing changes",
		plugin_manager_text = "Managing plugins",
		reading_text = "Reading %s",
		workspace_text = "Working on %s",
		line_number_text = "Line %s out of %s",
	},
}
