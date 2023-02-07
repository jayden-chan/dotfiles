require("config.options")
require("config.autocmd")
require("config.bindings")
require("config.iab")

local lazypath = "/home/jayden/.local/share/nvim/lazy/lazy.nvim"
local statpath = vim.loop.fs_stat(lazypath)
-- if not statpath then
-- 	vim.fn.system({
-- 		"git",
-- 		"clone",
-- 		"--filter=blob:none",
-- 		"https://github.com/folke/lazy.nvim.git",
-- 		"--branch=stable", -- latest stable release
-- 		lazypath,
-- 	})
-- end

vim.opt.rtp:prepend(lazypath)

vim.cmd("filetype on")
require("config.plugins")
vim.cmd("syntax enable")
