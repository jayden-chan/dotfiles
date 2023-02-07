local utils = require("config.utils")
return {
	utils.mirror("lexima.vim"),
	config = function()
		vim.g.lexima_map_escape = ""

		vim.g.lexima_enable_space_rules = 0
		vim.g.lexima_enable_endwise_rules = 0

		-- custom space rules, based on defaults
		vim.cmd(" call lexima#add_rule({'char': '<Space>', 'at': '(\\%#)', 'input_after': '<Space>'})  ")
		vim.cmd(" call lexima#add_rule({'char': ')', 'at': '\\%# )', 'leave': 2})                      ")
		vim.cmd(" call lexima#add_rule({'char': '<BS>', 'at': '( \\%# )', 'delete': 1})                ")
		vim.cmd(" call lexima#add_rule({'char': '<Space>', 'at': '{\\%#}', 'input_after': '<Space>'})  ")
		vim.cmd(" call lexima#add_rule({'char': '}', 'at': '\\%# }', 'leave': 2})                      ")
		vim.cmd(" call lexima#add_rule({'char': '<BS>', 'at': '{ \\%# }', 'delete': 1})                ")
		vim.cmd(" call lexima#add_rule({'char': '<Space>', 'at': '\\[\\[\\%#]]', 'input_after': '<Space>'}) ")
		vim.cmd(" call lexima#add_rule({'char': '<BS>', 'at': '\\[\\[ \\%# ]]', 'delete': 1})               ")
	end,
}
