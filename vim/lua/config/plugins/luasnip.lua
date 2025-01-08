local utils = require("config.utils")
return {
	utils.mirror("LuaSnip"),
	version = "v2.*",
	build = "make install_jsregexp",
	keys = {
		{ "<C-k>", "<Plug>luasnip-next-choice", mode = "i" },
		{ "<C-k>", "<Plug>luasnip-next-choice", mode = "s" },
		{
			"<Tab>",
			function()
				require("luasnip").jump(1)
			end,
			mode = "s",
		},
		{
			"<S-Tab>",
			function()
				require("luasnip").jump(-1)
			end,
			mode = "s",
		},
		{
			"<Tab>",
			function()
				if require("luasnip").expand_or_locally_jumpable() then
					return "<Plug>luasnip-expand-or-jump"
				end
				return "<Tab>"
			end,
			mode = "i",
			expr = true,
		},
	},
	config = function()
		local ls = require("luasnip")
		require("luasnip.loaders.from_lua").load({ paths = "~/.config/dotfiles/vim/snippets" })

		ls.config.set_config({
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

		ls.filetype_extend("cpp", { "c" })
		ls.filetype_extend("typescript", { "javascript" })
		ls.filetype_extend("typescriptreact", { "javascript" })
		ls.filetype_extend("javascriptreact", { "javascript" })
		ls.filetype_extend("template", { "html" })
	end,
}
