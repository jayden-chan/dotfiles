vim.opt.encoding = "UTF-8"
vim.opt.spellfile = os.getenv("HOME") .. "/.config/dotfiles/vim/en.utf-8.add"

vim.opt.fillchars = vim.opt.fillchars + "diff: "

-- 256 colors
vim.opt.termguicolors = true

vim.opt.swapfile = false
vim.opt.updatetime = 300

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
vim.opt.guicursor = "a:blinkwait1-blinkon1-blinkoff1,n-v:block,i-ci-ve:ver1,r:hor1"

vim.opt.laststatus = 3

-- Leader
vim.g.mapleader = " "

vim.g.rustfmt_autosave = 1
vim.g.sql_type_default = "pgsql"

vim.g.tmux_navigator_no_mappings = 1
