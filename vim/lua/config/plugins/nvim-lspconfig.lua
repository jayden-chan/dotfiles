local utils = require("config.utils")
local lsp_settings = require("config.lsp")
local ts_config = require("config.treesitter_langs")
local user_cmd = vim.api.nvim_buf_create_user_command

return {
	utils.mirror("nvim-lspconfig"),
	dependencies = {
		utils.mirror("blink.cmp"),
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
		-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local lspconfig = require("lspconfig")
		local lsp_util = require("lspconfig.util")
		local on_attach = lsp_settings.on_attach
		local on_init = lsp_settings.on_init
		local default_flags = lsp_settings.default_flags

		local default_lsp_config = {
			capabilities = capabilities,
			on_init = on_init,
			on_attach = on_attach,
			flags = default_flags,
		}

		---                       ---
		--- Language Server Setup ---
		---                       ---
		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			on_init = on_init,
			filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
			root_dir = lsp_util.root_pattern("package.json"),
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

		lspconfig.gopls.setup(default_lsp_config)
		lspconfig.clangd.setup(default_lsp_config)
		lspconfig.taplo.setup(default_lsp_config)
		lspconfig.yamlls.setup(default_lsp_config)
		lspconfig.nil_ls.setup(default_lsp_config)
		lspconfig.dartls.setup(default_lsp_config)

		lspconfig.tailwindcss.setup({
			capabilities = capabilities,
			on_init = on_init,
			on_attach = on_attach,
			flags = default_flags,
			filetypes = { "typescriptreact", "javascriptreact", "html" },
			settings = {
				tailwindCSS = {
					experimental = {
						classRegex = {
							{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
							{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						},
					},
				},
			},
			root_dir = function(fname)
				return lsp_util.root_pattern(
					"tailwind.config.js",
					"tailwind.config.cjs",
					"tailwind.config.mjs",
					"tailwind.config.ts",
					"postcss.config.js",
					"postcss.config.cjs",
					"postcss.config.mjs",
					"postcss.config.ts"
				)(fname)
			end,
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
