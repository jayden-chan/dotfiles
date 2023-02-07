require("config.options")
require("config.autocmd")
require("config.bindings")
require("config.iab")

vim.cmd("filetype on")
require("config.plugins")
vim.cmd("syntax enable")
