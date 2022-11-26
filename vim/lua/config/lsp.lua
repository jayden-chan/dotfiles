---     ---
--- LSP ---
---     ---

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>H", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
vim.api.nvim_set_keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
vim.api.nvim_set_keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
	local function buf_key(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({
					bufnr = bufnr,
				})
			end,
		})
	end

	buf_key("n", "<leader>o", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_key("n", "<leader>O", "<cmd>vs<CR><cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_key("n", "<leader>g", "<cmd>Lspsaga hover_doc<CR>", opts)
	buf_key("n", "<leader>G", "<cmd>Lspsaga peek_definition<CR>", opts)
	buf_key("n", "<leader>R", "<cmd>Lspsaga rename<CR>", opts)
	buf_key("n", "<leader>e", "<cmd>Lspsaga code_action<CR>", opts)
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
	virtual_text = {
		severity = vim.diagnostic.severity.ERROR,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = false,
})

---             ---
--- completions ---
---             ---
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

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
local default_flags = { debounce_text_changes = 150 }
local on_init = function(client)
	client.offset_encoding = "utf-8"
end

---                       ---
--- Language Server Setup ---
---                       ---
lspconfig.tsserver.setup({
	capabilities = capabilities,
	on_init = on_init,
	root_dir = require("lspconfig/util").root_pattern("package.json"),
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		on_attach(client, bufnr)
	end,
	flags = default_flags,
})

lspconfig.denols.setup({
	capabilities = capabilities,
	on_init = on_init,
	filetypes = { "typescript" },
	root_dir = require("lspconfig/util").root_pattern("deno.json", "deno.jsonc"),
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		on_attach(client, bufnr)
	end,
	flags = default_flags,
})

lspconfig.gopls.setup({
	capabilities = capabilities,
	on_init = on_init,
	on_attach = on_attach,
	flags = default_flags,
})

lspconfig.clangd.setup({
	capabilities = capabilities,
	on_init = on_init,
	on_attach = on_attach,
	flags = default_flags,
})

lspconfig.rust_analyzer.setup({
	capabilities = capabilities,
	on_init = on_init,
	on_attach = on_attach,
	flags = default_flags,
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
			completion = {
				postfix = {
					enable = false,
				},
			},
		},
	},
})

lspconfig.sumneko_lua.setup({
	capabilities = capabilities,
	on_init = on_init,
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		on_attach(client, bufnr)
	end,
	flags = default_flags,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim", "awesome", "client", "root", "screen" } },
			workspace = {
				library = {
					["/usr/local/share/nvim/runtime/lua"] = true,
					["/usr/local/share/nvim/runtime/lua/vim/lsp"] = true,
					["/usr/share/awesome/lib"] = true,
				},
			},
			telemetry = { enable = false },
			format = { enable = false },
		},
	},
})

local null_ls = require("null-ls")
null_ls.setup({
	capabilities = capabilities,
	on_init = on_init,
	on_attach = on_attach,
	flags = default_flags,
	sources = {
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.diagnostics.cppcheck,
		null_ls.builtins.diagnostics.eslint_d.with({
			condition = function(utils)
				return utils.root_has_file({
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.yaml",
					".eslintrc.yml",
					".eslintrc.json",
				})
			end,
		}),
	},
})

local saga = require("lspsaga")
saga.init_lsp_saga({
	code_action_icon = "",
	code_action_lightbulb = {
		enable = true,
		enable_in_insert = false,
		cache_code_action = false,
		sign = true,
		update_time = 150,
		sign_priority = 20,
		virtual_text = true,
	},
})

require("trouble").setup({
	position = "bottom",
	height = 10,
	width = 50,
	icons = true,
	mode = "workspace_diagnostics",
	fold_open = "",
	fold_closed = "",
	group = true,
	padding = true,
	action_keys = {
		close = "q",
		cancel = "<esc>",
		refresh = "r",
		jump_close = { "<cr>", "<tab>" },
		open_split = { "<c-x>" },
		open_vsplit = { "<c-v>" },
		open_tab = { "<c-t>" },
		jump = { "o" },
		toggle_mode = "m",
		toggle_preview = "P",
		hover = "K",
		preview = "p",
		close_folds = { "zM", "zm" },
		open_folds = { "zR", "zr" },
		toggle_fold = { "zA", "za" },
		previous = "i",
		next = "k",
	},
	indent_lines = true,
	auto_open = false,
	auto_close = false,
	auto_preview = true,
	auto_fold = false,
	auto_jump = { "lsp_definitions" },
	signs = {
		error = "",
		warning = "",
		hint = "",
		information = "",
		other = "﫠",
	},
	use_diagnostic_signs = false,
})
