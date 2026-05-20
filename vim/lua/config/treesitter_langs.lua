local base = {
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"go",
	"graphql",
	"hcl",
	"html",
	"http",
	"hurl",
	"java",
	"javascript",
	"json",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"nginx",
	"nix",
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
	"zsh",
}

local extended = vim.list_extend(vim.deepcopy(base), {
	"typescriptreact",
	"javascriptreact",
	"sh",
})

return {
	base = base,
	extended = extended,
}
