local utils = require("config.utils")
local lsp_config = require("config.lsp")
local ts_config = require("config.treesitter_langs")

return {
	utils.mirror("none-ls.nvim"),
	dependencies = {
		utils.mirror("cmp-nvim-lsp"),
		"gbprod/none-ls-shellcheck.nvim",
		"nvimtools/none-ls-extras.nvim",
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
				null_ls.builtins.formatting.nixfmt,
				null_ls.builtins.formatting.sql_formatter.with({
					extra_args = {
						"--config",
						'{"language":"postgresql","dialect":"postgresql","tabWidth":4}',
					},
				}),
				require("none-ls-shellcheck.diagnostics"),
				require("none-ls-shellcheck.code_actions"),
				require("none-ls.diagnostics.cpplint"),
				null_ls.builtins.formatting.terraform_fmt,
				require("none-ls.diagnostics.eslint_d").with({
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
