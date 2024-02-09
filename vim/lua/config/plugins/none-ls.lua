local utils = require("config.utils")
local lsp_config = require("config.lsp")
local ts_config = require("config.treesitter_langs")

return {
	utils.mirror("none-ls.nvim"),
	dependencies = {
		utils.mirror("cmp-nvim-lsp"),
	},
	ft = ts_config.extended,
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local null_ls = require("null-ls")
		null_ls.setup({
			capabilities = capabilities,
			on_init = lsp_config.on_init,
			on_attach = lsp_config.on_attach,
			flags = lsp_config.default_flags,
			sources = {
				null_ls.builtins.formatting.prettierd,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.diagnostics.shellcheck,
				null_ls.builtins.formatting.taplo,
				null_ls.builtins.code_actions.shellcheck,
				null_ls.builtins.diagnostics.cppcheck,
				null_ls.builtins.formatting.terraform_fmt,
				null_ls.builtins.diagnostics.eslint_d.with({
					condition = function(utls)
						return utls.root_has_file({
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
	end,
}
