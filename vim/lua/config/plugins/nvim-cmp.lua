local utils = require("config.utils")
return {
	utils.mirror("nvim-cmp"),
	dependencies = {
		utils.mirror("cmp-nvim-lsp"),
		utils.mirror("cmp-buffer"),
		utils.mirror("cmp-git"),
		utils.mirror("cmp-path"),
		utils.mirror("cmp-cmdline"),
		utils.mirror("cmp-nvim-ultisnips"),
		utils.mirror("lspkind-nvim"),
	},
	event = "InsertEnter",
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")

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

		cmp.setup({
			snippet = {
				expand = function(args)
					vim.fn["UltiSnips#Anon"](args.body)
				end,
			},
			preselect = cmp.PreselectMode.None,
			window = {
				completion = {
					winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
					col_offset = -3,
					side_padding = 0,
				},
			},
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
					local strings = vim.split(kind.kind, "%s", { trimempty = true })

					-- Handle un-implemented case in lspkind
					-- https://github.com/onsails/lspkind.nvim/issues/12
					if strings[1] == "TypeParameter" then
						strings[1] = ""
						strings[2] = "Type Parameter"
					end

					kind.kind = " " .. strings[1] .. " "
					kind.menu = "    (" .. strings[2] .. ")"

					return kind
				end,
			},
			mapping = cmp.mapping.preset.insert({
				-- Enter immediately completes. C-n/C-p to select.
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "ultisnips" },
				{ name = "path" },
			}, {
				buffer_cmp,
			}),
		})

		-- Set configuration for specific filetype.
		require("cmp_git").setup()
		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({ { name = "git" } }, { buffer_cmp }),
		})

		cmp.setup.filetype("NeogitCommitMessage", {
			sources = cmp.config.sources({ { name = "git" } }, { buffer_cmp }),
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
