local utils = require("config.utils")
return {
	utils.mirror("nvim-cmp"),
	dependencies = {
		utils.mirror("cmp-nvim-lsp"),
		utils.mirror("cmp-buffer"),
		utils.mirror("cmp-git"),
		utils.mirror("cmp-path"),
		utils.mirror("cmp-cmdline"),
		utils.mirror("cmp_luasnip"),
		utils.mirror("lspkind-nvim"),
	},
	event = "InsertEnter",
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")
		local luasnip = require("luasnip")

		local buffer_cmp = {
			name = "buffer",
			option = {
				-- get buffer completions from all visible buffers
				get_bufnrs = function()
					local bufs = {}
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						bufs[vim.api.nvim_win_get_buf(win)] = true
					end
					return vim.tbl_keys(bufs)
				end,
			},
		}

		local default_cmp_sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "path" },
		}, {
			buffer_cmp,
		})

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			preselect = cmp.PreselectMode.None,
			window = {
				completion = {
					winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
					col_offset = -3,
					side_padding = 1,
				},
			},
			formatting = {
				fields = { "abbr", "kind" },
				format = function(entry, vim_item)
					local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
					local strings = vim.split(kind.kind, "%s", { trimempty = true })

					-- Handle un-implemented case in lspkind
					-- https://github.com/onsails/lspkind.nvim/issues/12
					if strings[1] == "TypeParameter" then
						strings[1] = ""
						strings[2] = "Type Parameter"
					end

					local s1 = strings[1] or ""
					local s2 = strings[2] or ""

					kind.kind = " " .. s1 .. " " .. s2
					return kind
				end,
			},
			mapping = cmp.mapping.preset.insert({
				-- Enter immediately completes. C-n/C-p to select.
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = default_cmp_sources,
		})

		-- Set configuration for specific filetype.
		require("cmp_git").setup()
		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({ { name = "git" } }, { buffer_cmp }),
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(t)
				if string.find(t.file, "lakehouse%-query%-") ~= nil then
					print(string.format("event fired: %s", vim.inspect(t)))
					cmp.setup.buffer({
						sources = cmp.config.sources({ { name = "vim-dadbod-completion" } }, { buffer_cmp }),
					})
				end
			end,
		})

		-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline("/", {
			sources = { buffer_cmp },
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
		})
	end,
}
