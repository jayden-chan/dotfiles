local utils = require("config.utils")
local lsp_settings = require("config.lsp")
local ts_config = require("config.treesitter_langs")
local user_cmd = vim.api.nvim_buf_create_user_command

return {
	utils.mirror("nvim-lspconfig"),
	dependencies = {
		utils.mirror("cmp-nvim-lsp"),
		utils.mirror("lspsaga.nvim"),
	},
	ft = ts_config.extended,
	config = function()
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

		-- Setup lspconfig.
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local lspconfig = require("lspconfig")
		local lsp_util = require("lspconfig.util")
		local on_attach = lsp_settings.on_attach
		local on_init = lsp_settings.on_init
		local default_flags = lsp_settings.default_flags

		---                       ---
		--- Language Server Setup ---
		---                       ---
		lspconfig.tsserver.setup({
			capabilities = capabilities,
			on_init = on_init,
			filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
			root_dir = lsp_util.root_pattern("package.json"),
			single_file_support = false,
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false

				user_cmd(bufnr, "TSOrganizeImports", function()
					vim.lsp.buf.execute_command({
						command = "_typescript.organizeImports",
						arguments = { vim.fn.expand("%:p") },
					})
				end, { nargs = 0 })

				on_attach(client, bufnr)
			end,
			flags = default_flags,
		})

		lspconfig.denols.setup({
			capabilities = capabilities,
			on_init = on_init,
			filetypes = { "typescript" },
			root_dir = lsp_util.root_pattern("deno.json", "deno.jsonc"),
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
					checkOnSave = {
						allFeatures = true,
						overrideCommand = {
							"cargo",
							"clippy",
							"--workspace",
							"--message-format=json",
							"--all-targets",
							"--all-features",
						},
					},
					completion = {
						postfix = {
							enable = false,
						},
					},
				},
			},
		})

		lspconfig.lua_ls.setup({
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
	end,
}
