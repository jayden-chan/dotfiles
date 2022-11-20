local g = vim.g
local opt = vim.opt

opt.encoding = "UTF-8"
opt.spellfile = os.getenv("HOME") .. "/.config/dotfiles/vim/en.utf-8.add"

vim.cmd([[set fillchars+=diff:\ ]])

-- 256 colors
opt.termguicolors = true

-- Tab settings
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.smarttab = true
opt.smartindent = true

-- Search settings
opt.gdefault = true -- Global by default
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Override ignorecase if search contains capitals
opt.incsearch = true -- Search incrementally
opt.hls = false -- Don't highlight after Enter is pressed
opt.inccommand = "nosplit" -- Show find/replace as it is typed

-- Open new splits on the right
opt.splitright = true

-- Fold settings
opt.foldlevel = 1000
opt.foldmethod = "indent"

opt.undolevels = 9001
opt.cursorline = true

-- Wrap
opt.wrap = true

-- No command bar
opt.showmode = false

-- Hide ugly completion messages
vim.cmd("set shortmess+=c")

-- Leave signcolumn on so it's not toggling all the time
opt.signcolumn = "yes"

-- Don't let the cursor reach the top/bottom 8 lines of text
opt.scrolloff = 8

-- Don't automatically update working dir
opt.autochdir = false

-- Completion menu settings
opt.completeopt = { "menu", "menuone", "noselect" }

-- unload and delete the buffer once there are no more
-- windows referencing it
opt.hidden = false

-- Unix file line endings
opt.fileformat = "unix"

-- Line numbers and relative line numbers
opt.number = true
opt.relativenumber = true

-- Enable mouse
opt.mouse = "a"

-- Change cursor to bar and underscore for different modes
vim.cmd([[let &t_SI = "\<Esc>[6 q"]])
vim.cmd([[let &t_SR = "\<Esc>[4 q"]])
vim.cmd([[let &t_EI = "\<Esc>[2 q"]])

-- Leader
vim.cmd([[let mapleader = "\<Space>"]])

g.UltiSnipsExpandTrigger = "<tab>"
g.UltiSnipsJumpForwardTrigger = "<tab>"

g.Hexokinase_optInPatterns = {
	"full_hex",
	"triple_hex",
	"rgb",
	"rgba",
	"hsl",
	"hsla",
}

g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }

g.rustfmt_autosave = 1
g.sql_type_default = "pgsql"

g.tex_flavor = "latex"
g.tex_conceal = ""
g.vim_markdown_conceal = 0
g.vim_markdown_conceal_code_blocks = 0
g.tmux_navigator_no_mappings = 1
