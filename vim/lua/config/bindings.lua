local cmd = vim.cmd

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Relative line number toggle, toggle w/ F9
map("n", "<F9>", "<cmd>set rnu!<cr>")

-- Map Ctrl-s to save
map("n", "<c-s>", ":wa<cr>", { silent = false })
map("i", "<c-s>", "<esc>:wa<cr>", { silent = false })

-- Spell check
map("n", "<F6>", ":setlocal spell! spelllang=en_us<cr>", { silent = false })

-- ctrl-o corrects previous spelling mistake while in insert mode
map("i", "<c-o>", "<c-g>u<Esc>[s1z=`]a<c-g>u")

-- Make Esc work in terminal mode
map("t", "<esc>", [[<C-\><C-n>]])

-- Formatting (remove whitespace and reindent)
map("n", "<leader>ww", [[<cmd>%s/\s\+$//e<cr>]], { silent = false })
map("n", "<leader>ta", "<cmd>Tabularize /<bar><cr>")

-- Close quickfix/preview/location
map("", "<c-q>", "<cmd>ccl<bar>pcl<bar>lcl<cr>")

-- Fuzzy finding
map("n", "<leader>f", '<cmd>lua require("telescope.builtin").find_files()<cr>')
map("n", "<leader>r", '<cmd>lua require("telescope.builtin").live_grep()<cr>')
map("n", "<leader>b", '<cmd>lua require("telescope.builtin").buffers()<cr>')
map("n", "<leader>hh", '<cmd>lua require("telescope.builtin").help_tags()<cr>')
map("n", "<leader>n", '<cmd>lua require("telescope.builtin").lsp_references()<cr>')
map("n", "<leader>z", '<cmd>lua require("telescope.builtin").spell_suggest()<cr>')

cmd([[
com! CheckHighlightUnderCursor echo {l,c,n ->
        \   'hi<'    . synIDattr(synID(l, c, 1), n)             . '> '
        \  .'trans<' . synIDattr(synID(l, c, 0), n)             . '> '
        \  .'lo<'    . synIDattr(synIDtrans(synID(l, c, 1)), n) . '> '
        \ }(line("."), col("."), "name")
]])

-- Neogit
map("n", "<leader>N", '<cmd>lua require("neogit").open({ kind = "replace" })<cr>')

-- Undo tree
map("n", "<leader>U", "<cmd>UndotreeToggle<CR>")

-- Remap cursor movement keys because I'm a scrub and don't use the default
map("", "h", "i")
map("", "j", "h")
map("", "k", "gj")
map("", "i", "gk")

-- Various other cursor control maps
map("n", "L", "g$")
map("n", "J", "g^")
map("v", "L", "$")
map("v", "J", "^")
map("n", "I", "12<c-u>")
map("n", "K", "12<c-d>")
map("v", "I", "12<up>")
map("v", "K", "12<down>")
map("n", "U", "J")

-- Make X and Y behave like C and D
map("n", "Y", "y$")
map("n", "X", 'v$<Left>"_x')

-- Move the cursor more easily while in insert mode
map("i", "<c-j>", "<Left>")
map("i", "<c-l>", "<Right>")

-- Easily resize splits
map("n", "<leader>j", "<cmd>vertical resize +5<CR>", { silent = false })
map("n", "<leader>k", "<cmd>resize +2<CR>", { silent = false })
map("n", "<leader>i", "<cmd>resize -2<CR>", { silent = false })
map("n", "<leader>l", "<cmd>vertical resize -5<CR>", { silent = false })

-- Make c-p function like c-i since c-i was previously remapped
map("n", "<c-p>", "<c-i>")

-- <leader><leader> toggles between buffers
map("n", "<leader><leader>", "<c-^>", { silent = false })

-- Disable Ex mode
map("", "q:", "<nop>")
map("", "Q", "<nop>")

-- New line no insert mode
map("n", "go", "o<Esc>")

-- Copy Paste etc from system clipboard
cmd([[map <silent> <leader>p "+p]])
cmd([[map <silent> <leader>y "+y]])

-- Delete line without filling yank buffer
cmd([[nnoremap <silent> <leader>dd "_dd]])
cmd([[vnoremap <silent> <leader>dd "_dd]])

-- Prevent x and c from filling buffer
cmd([[noremap x "_x]])
cmd([[noremap c "_c]])
cmd([[noremap cc "_cc]])

-- Tab switching
map("n", "<tab>j", ":tabprevious<CR>", { silent = false })
map("n", "<tab>l", ":tabnext<CR>", { silent = false })

-- Fix 'I' behaviour in V-block
map("v", "H", "I")

-- Toggle highlight search
map("n", "<leader>h", ":set hls!<CR>", { silent = false })

-- nvim-tree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>")

-- tmux navigator
map("n", "<M-j>", "<cmd>TmuxNavigateLeft<cr>")
map("n", "<M-k>", "<cmd>TmuxNavigateDown<cr>")
map("n", "<M-i>", "<cmd>TmuxNavigateUp<cr>")
map("n", "<M-l>", "<cmd>TmuxNavigateRight<cr>")
