local lsp_settings = require("config.lsp")
local ts_config = require("config.treesitter_langs")
local user_cmd = vim.api.nvim_buf_create_user_command

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"Saghen/blink.cmp",
		"nvimdev/lspsaga.nvim",
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
		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			on_init = on_init,
			filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
			root_markers = { "package.json" },
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
		vim.lsp.enable({ "ts_ls" })

		vim.lsp.config("bashls", default_lsp_config)
		vim.lsp.enable({ "bashls" })

		vim.lsp.config("gopls", default_lsp_config)
		vim.lsp.enable({ "gopls" })

		vim.lsp.config("clangd", default_lsp_config)
		vim.lsp.enable({ "clangd" })

		vim.lsp.config("taplo", default_lsp_config)
		vim.lsp.enable({ "taplo" })

		vim.lsp.config("yamlls", default_lsp_config)
		vim.lsp.enable({ "yamlls" })

		vim.lsp.config("nil_ls", default_lsp_config)
		vim.lsp.enable({ "nil_ls" })

		vim.lsp.config("tailwindcss", {
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
		})
		vim.lsp.enable({ "tailwindcss" })

		vim.lsp.config("rust_analyzer", {
			capabilities = capabilities,
			on_init = on_init,
			on_attach = on_attach,
			flags = default_flags,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
					},
					checkOnSave = true,
					-- check = {
					-- 	features = "all",
					-- 	command = "cargo clippy --workspace --message-format=json --all-targets --all-features",
					-- },
					completion = {
						postfix = {
							enable = false,
						},
					},
				},
			},
		})
		vim.lsp.enable({ "rust_analyzer" })

		vim.lsp.config("lua_ls", {
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
					telemetry = { enable = false },
					format = { enable = false },
				},
			},
		})
		vim.lsp.enable({ "lua_ls" })
	end,
}
