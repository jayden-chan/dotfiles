local utils = require("config.utils")
local lsp_settings = require("config.lsp")
return {
	utils.mirror("nvim-lspconfig"),
	dependencies = {
		utils.mirror("cmp-nvim-lsp"),
	},
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
		local on_attach = lsp_settings.on_attach
		local on_init = lsp_settings.on_init
		local default_flags = lsp_settings.default_flags

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
	end,
}
