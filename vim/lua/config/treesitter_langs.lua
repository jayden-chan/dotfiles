local base = {
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"dockerfile",
	"go",
	"graphql",
	"hcl",
	"http",
	"java",
	"javascript",
	"json",
	"jsonc",
	"latex",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"rasi",
	"rust",
	"sql",
	"terraform",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"yaml",
}

local extended = vim.list_extend(vim.deepcopy(base), {
	"typescriptreact",
	"javascriptreact",
})

return {
	base = base,
	extended = extended,
}
