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
	"html",
	"http",
	"hurl",
	"java",
	"javascript",
	"json",
	"jsonc",
	"just",
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
