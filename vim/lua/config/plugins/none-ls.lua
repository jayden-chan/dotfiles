local utils = require("config.utils")
local lsp_config = require("config.lsp")
local ts_config = require("config.treesitter_langs")

return {
	utils.mirror("none-ls.nvim"),
	dependencies = {
		utils.mirror("blink.cmp"),
		utils.mirror("none-ls-shellcheck.nvim"),
		utils.mirror("none-ls-extras.nvim"),
	},
	ft = ts_config.extended,
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local null_ls = require("null-ls")
		local sql_dialect = os.getenv("SQL_DIALECT") or "postgresql"

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
						'{"tabWidth":4,"keywordCase":"upper","language":"'
							.. sql_dialect
							.. '","dialect":"'
							.. sql_dialect
							.. '"}',
					},
				}),
				require("none-ls-shellcheck.diagnostics"),
				require("none-ls-shellcheck.code_actions"),
				require("none-ls.diagnostics.cpplint"),
				null_ls.builtins.formatting.terraform_fmt,
				require("none-ls.diagnostics.eslint_d").with({
					condition = function(utls)
						return utls.root_has_file({
							"eslint.config.js",
							"eslint.config.mjs",
							".null-ls-enable-eslint",
						})
					end,
				}),
			},
		})
	end,
}
