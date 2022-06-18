local cmd = vim.cmd
local new_command = vim.api.nvim_create_user_command

cmd([[autocmd FileType gitcommit,NeogitCommitMessage,text,markdown,tex let b:EditorConfig_disable = 1]])
cmd([[command! -nargs=0 AutoFormat :lua vim.lsp.buf.formatting_sync()]])

local auto_fmt_langs = {
	"c",
	"cpp",
	"css",
	"go",
	"graphql",
	"html",
	"javascript",
	"javascriptreact",
	"json",
	"lua",
	"scss",
	"typescript",
	"typescriptreact",
}

for _, v in ipairs(auto_fmt_langs) do
	cmd("autocmd FileType " .. v .. " autocmd BufWritePre <buffer> AutoFormat")
end

local spell_langs = {
	"gitcommit",
	"NeogitCommitMessage",
	"text",
	"markdown",
	"tex",
	"cucumber",
}

for _, v in ipairs(spell_langs) do
	cmd("autocmd FileType " .. v .. " setlocal spell spelllang=en_us")
end

-- Set a max line length for Markdown files
cmd([[autocmd FileType markdown setlocal textwidth=89]])
cmd([[autocmd FileType markdown setlocal colorcolumn=90]])

-- Set indentation to 2 spaces for certain files
local two_spc_files = {
	"cpp",
	"css",
	"graphql",
	"groovy",
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
	cmd("autocmd FileType " .. v .. " setlocal shiftwidth=2")
	cmd("autocmd FileType " .. v .. " setlocal softtabstop=2")
end

-- Enter insert mode automatically when entering terminal
cmd([[autocmd BufWinEnter,WinEnter term://* startinsert]])

-- Jump to last known cursor position when opening files
cmd(
	[[autocmd BufReadPost * if &filetype != "gitcommit" && &filetype != "NeogitCommitMessage" && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
)

cmd([[autocmd BufRead,BufNewFile Jenkinsfile setf groovy]])
cmd([[autocmd BufRead,BufNewFile *.graphql setf graphql]])

-- Set indentation to hard tabs for some files
cmd([[autocmd FileType snippets,go,lua setlocal tabstop=4]])
cmd([[autocmd FileType snippets,go,lua setlocal shiftwidth=4]])
cmd([[autocmd FileType asm             setlocal shiftwidth=8]])
cmd([[autocmd FileType asm             setlocal expandtab]])
cmd([[autocmd FileType go,lua          setlocal noexpandtab]])
cmd([[autocmd FileType makefile        setlocal noexpandtab]])

new_command(
	"TSOrganizeImports",
	'<cmd>lua vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})',
	{ nargs = 0 }
)

-- Make leaving easier in case of typos
cmd([[command! -bang Q :q<bang>]])
cmd([[command! Wq :wq]])
cmd([[command! WQ :wq]])
cmd([[command! Wqa :wqa]])
cmd([[command! WQa :wqa]])
cmd([[command! WQA :wqa]])
cmd([[command! -bang Qa :qa<bang>]])
cmd([[command! -bang QA :qa<bang>]])

cmd([[command! RustDocs :silent !rustup doc --std]])
