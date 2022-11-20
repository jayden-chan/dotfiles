vim.opt.encoding = "UTF-8"
vim.opt.spellfile = os.getenv("HOME") .. "/.config/dotfiles/vim/en.utf-8.add"

vim.opt.fillchars = vim.opt.fillchars + "diff: "

-- 256 colors
vim.opt.termguicolors = true

-- Tab settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.smartindent = true

-- Search settings
vim.opt.gdefault = true -- Global by default
vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true -- Override ignorecase if search contains capitals
vim.opt.incsearch = true -- Search incrementally
vim.opt.hls = false -- Don't highlight after Enter is pressed
vim.opt.inccommand = "nosplit" -- Show find/replace as it is typed

-- Open new splits on the right
vim.opt.splitright = true

-- Fold settings
vim.opt.foldlevel = 1000
vim.opt.foldmethod = "indent"

vim.opt.undolevels = 9001
vim.opt.cursorline = true

-- Wrap
vim.opt.wrap = true

-- No command bar
vim.opt.showmode = false

-- Hide ugly completion messages
vim.opt.shortmess = vim.opt.shortmess + "c"

-- Leave signcolumn on so it's not toggling all the time
vim.opt.signcolumn = "yes"

-- Don't let the cursor reach the top/bottom 8 lines of text
vim.opt.scrolloff = 8

-- Don't automatically update working dir
vim.opt.autochdir = false

-- Completion menu settings
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- unload and delete the buffer once there are no more
-- windows referencing it
vim.opt.hidden = false

-- Unix file line endings
vim.opt.fileformat = "unix"

-- Line numbers and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse
vim.opt.mouse = "a"

-- Change cursor to bar and underscore for different modes
vim.cmd([[let &t_SI = "\<Esc>[6 q"]])
vim.cmd([[let &t_SR = "\<Esc>[4 q"]])
vim.cmd([[let &t_EI = "\<Esc>[2 q"]])

-- Leader
vim.g.mapleader = " "

vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"

vim.g.Hexokinase_optInPatterns = {
	"full_hex",
	"triple_hex",
	"rgb",
	"rgba",
	"hsl",
	"hsla",
}

vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }

vim.g.rustfmt_autosave = 1
vim.g.sql_type_default = "pgsql"

vim.g.lexima_map_escape = ""

vim.g.tex_flavor = "latex"
vim.g.tex_conceal = ""
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.tmux_navigator_no_mappings = 1
