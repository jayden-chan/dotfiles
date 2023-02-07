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

	local bind_opts = { noremap = true, silent = true }
	buf_key("n", "<leader>H", "<cmd>Lspsaga show_cursor_diagnostics<CR>", bind_opts)
	buf_key("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", bind_opts)
	buf_key("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", bind_opts)
	buf_key("n", "<leader>o", "<cmd>lua vim.lsp.buf.definition()<CR>", bind_opts)
	buf_key("n", "<leader>O", "<cmd>vs<CR><cmd>lua vim.lsp.buf.definition()<CR>", bind_opts)
	buf_key("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", bind_opts)
	buf_key("n", "<leader>P", "<cmd>Lspsaga lsp_finder<CR>", bind_opts)
	buf_key("n", "<leader>g", "<cmd>Lspsaga hover_doc<CR>", bind_opts)
	buf_key("n", "<leader>G", "<cmd>Lspsaga peek_definition<CR>", bind_opts)
	buf_key("n", "<leader>R", "<cmd>Lspsaga rename<CR>", bind_opts)
	buf_key("n", "<leader>e", "<cmd>Lspsaga code_action<CR>", bind_opts)
	buf_key("n", "<leader>T", "<cmd>Trouble<CR>", bind_opts)
end

local on_init = function(client)
	client.offset_encoding = "utf-8"
end

local default_flags = { debounce_text_changes = 150 }

return {
	on_attach = on_attach,
	on_init = on_init,
	default_flags = default_flags,
}
