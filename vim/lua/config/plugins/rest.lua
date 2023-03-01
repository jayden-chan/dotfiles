local utils = require("config.utils")
return {
	utils.mirror("rest.nvim"),
	lazy = true,
	dependencies = { utils.mirror("plenary.nvim") },
	cmd = { "RestNvim", "RestNvimPreview" },
	keys = {
		{ "<leader>c", "<plug>RestNvim" },
		{ "<leader>C", "<plug>RestNvimPreview" },
	},
	opts = {},
}
