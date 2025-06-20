local utils = require("config.utils")

return {
	utils.mirror("blink.cmp"),
	-- lazy loading handled internally
	lazy = false,
	dependencies = { utils.mirror("LuaSnip") },

	-- use a release tag to download pre-built binaries
	version = "v0.*",

	opts = {
		sources = { default = { "lsp", "path", "buffer" } },
		keymap = { preset = "default", ["<Tab>"] = {} },

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		signature = { enabled = false },

		completion = {
			trigger = { show_on_insert_on_trigger_character = false },
			menu = {
				scrollbar = false,
				auto_show = function()
					return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
				end,
			},
			list = { selection = { preselect = false, auto_insert = true } },
		},
	},
	opts_extend = { "sources.default" },
}
