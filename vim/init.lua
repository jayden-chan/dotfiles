local cmd = vim.cmd

cmd("filetype on")
require("config.plugins")
cmd("syntax enable")

require("config.options")
require("config.bindings")
require("config.autocmd")
require("config.iab")

require("config.plugin_config")
require("config.lsp")
require("config.treesitter")
require("config.nvimtree")
require("config.lualine")
