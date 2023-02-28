local user_cmd = vim.api.nvim_create_user_command

vim.cmd([[autocmd FileType gitcommit,NeogitCommitMessage,text,markdown,tex let b:EditorConfig_disable = 1]])

local spell_langs = {
	"gitcommit",
	"NeogitCommitMessage",
	"text",
	"markdown",
	"tex",
	"cucumber",
}

for _, v in ipairs(spell_langs) do
	vim.cmd("autocmd FileType " .. v .. " setlocal spell spelllang=en_us")
end

-- Set a max line length for Markdown files
vim.cmd([[autocmd FileType markdown setlocal textwidth=89]])
vim.cmd([[autocmd FileType markdown setlocal colorcolumn=90]])

-- Set indentation to 2 spaces for certain files
local two_spc_files = {
	"cpp",
	"css",
	"graphql",
	"groovy",
	"helm",
	"html",
	"javascript",
	"json",
	"jsonc",
	"less",
	"scss",
	"sql",
	"toml",
	"typescript",
	"typescriptreact",
	"yaml",
	"yml",
}

for _, v in ipairs(two_spc_files) do
	vim.cmd("autocmd FileType " .. v .. " setlocal shiftwidth=2")
	vim.cmd("autocmd FileType " .. v .. " setlocal softtabstop=2")
end

-- Jump to last known cursor position when opening files
vim.cmd(
	[[autocmd BufReadPost * if &filetype != "gitcommit" && &filetype != "NeogitCommitMessage" && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
)

vim.cmd([[autocmd BufRead,BufNewFile Jenkinsfile setf groovy]])
vim.cmd([[autocmd BufRead,BufNewFile *.graphql setf graphql]])
vim.cmd([[autocmd BufRead,BufNewFile *.rasi setf rasi]])

-- Set indentation to hard tabs for some files
vim.cmd([[autocmd FileType snippets,go,lua setlocal tabstop=4]])
vim.cmd([[autocmd FileType snippets,go,lua setlocal shiftwidth=4]])
vim.cmd([[autocmd FileType asm             setlocal shiftwidth=8]])
vim.cmd([[autocmd FileType asm             setlocal expandtab]])
vim.cmd([[autocmd FileType go,lua          setlocal noexpandtab]])
vim.cmd([[autocmd FileType makefile        setlocal noexpandtab]])

user_cmd("RustDocs", ":silent !rustup doc --std", {})

-- Make leaving easier in case of typos
user_cmd("Q", ":q<bang>", { bang = true })
user_cmd("Qa", ":qa<bang>", { bang = true })
user_cmd("QA", ":qa<bang>", { bang = true })
user_cmd("Wq", ":wq", {})
user_cmd("WQ", ":wq", {})
user_cmd("Wqa", ":wqa", {})
user_cmd("WQa", ":wqa", {})
user_cmd("WQA", ":wqa", {})
