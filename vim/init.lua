vim.cmd("filetype on")
require("config.plugins")
vim.cmd("syntax enable")

require("config.options")
require("config.bindings")
require("config.autocmd")
require("config.iab")

require("config.plugin_config")
require("config.lsp")
require("config.treesitter")
require("config.neotree")
require("config.lualine")
