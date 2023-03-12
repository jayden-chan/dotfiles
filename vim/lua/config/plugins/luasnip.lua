local utils = require("config.utils")
return {
	utils.mirror("LuaSnip"),
	build = "make install_jsregexp",
	keys = {
		{ "<C-k>", "<Plug>luasnip-next-choice", mode = "i" },
		{ "<C-k>", "<Plug>luasnip-next-choice", mode = "s" },
	},
	config = function()
		local luasnip = require("luasnip")
		require("luasnip.loaders.from_lua").load({ paths = "~/.config/dotfiles/vim/luasnip" })
		luasnip.config.set_config({
			history = false,
			updateevents = "TextChanged,TextChangedI",
			ext_opts = {
				[require("luasnip.util.types").choiceNode] = {
					active = {
						virt_text = { { "<- Choice", "Info" } },
					},
				},
			},
		})

		luasnip.filetype_extend("cpp", { "c" })
		luasnip.filetype_extend("typescript", { "javascript" })
		luasnip.filetype_extend("typescriptreact", { "javascript" })
		luasnip.filetype_extend("javascriptreact", { "javascript" })
	end,
}
