-- Finds sql-format-via-python somewhere in your nvim config path
local bin = vim.api.nvim_get_runtime_file("bin/sql-format-via-python.py", false)[1]

local run_formatter = function(text)
	local split = vim.split(text, "\n")
	local result = table.concat(vim.list_slice(split, 2, #split - 1), "\n")

	local j = require("plenary.job"):new({
		command = "python",
		args = { bin },
		writer = { result },
	})
	return j:sync()
end

local embedded_sql = vim.treesitter.parse_query(
	"rust",
	[[
(macro_invocation
	(scoped_identifier
		path: (identifier) @_path (#eq? @_path "sqlx")
		name: (identifier) @_name (#any-of? @_name "query" "query_as")
	)

	(token_tree
		(raw_string_literal) @sql
	)

	(#offset! @sql 0 3 0 -2)
)
]]
)

local get_root = function(bufnr)
	local parser = vim.treesitter.get_parser(bufnr, "rust", {})
	local tree = parser:parse()[1]
	return tree:root()
end

local format_dat_sql = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	if vim.bo[bufnr].filetype ~= "rust" then
		vim.notify("can only be used in rust")
		return
	end

	local root = get_root(bufnr)
	local changes = {}
	local text_to_format = ""
	for id, node in embedded_sql:iter_captures(root, bufnr, 0, -1) do
		local name = embedded_sql.captures[id]
		if name == "sql" then
			-- { start row, start col, end row, end col }
			local range = { node:range() }
			text_to_format = text_to_format .. "\n---\n" .. vim.treesitter.get_node_text(node, bufnr)
			table.insert(changes, 1, {
				range = range,
				formatted = {},
			})
		end
	end

	if #changes == 0 then
		return
	end

	-- Run the formatter, based on the node text
	local formatted = run_formatter(text_to_format)
	local i = 1
	local j = 1
	local indentation = string.rep(" ", changes[i].range[2])
	for _, line in ipairs(formatted) do
		if line == "---" then
			i = i + 1
			j = 0
			indentation = string.rep(" ", changes[i].range[2])
		else
			changes[i].formatted[j] = indentation .. line
			j = j + 1
		end
	end

	for _, change in ipairs(changes) do
		vim.api.nvim_buf_set_lines(bufnr, change.range[1] + 1, change.range[3], false, change.formatted)
	end
end

vim.api.nvim_create_user_command("SqlMagic", function()
	format_dat_sql()
end, {})

local group = vim.api.nvim_create_augroup("rust-sql-magic", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	pattern = "*.rs",
	callback = function()
		format_dat_sql()
	end,
})
