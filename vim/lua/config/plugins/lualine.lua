local utils = require("config.utils")
return {
	utils.mirror("lualine.nvim"),
	dependencies = {
		utils.mirror("base46.nvim"),
	},
	config = function()
		---        ---
		--- base46 ---
		---        ---
		local present, base46 = pcall(require, "base46")
		if not present then
			return
		end
		local theme = "gruvchad"
		local color_base = "base46"
		local theme_opts = {
			base = color_base,
			theme = theme,
			transparency = false,
		}
		base46.load_theme(theme_opts)
		local colors = base46.get_colors(color_base, theme)

		---         ---
		--- lualine ---
		---         ---
		local function diff_source()
			local gitsigns = vim.b.gitsigns_status_dict
			if gitsigns then
				return {
					added = gitsigns.added,
					modified = gitsigns.changed,
					removed = gitsigns.removed,
				}
			end
		end

		local function trailing_whitespace()
			local space = vim.fn.search([[\s\+$]], "nwc")
			return space ~= 0 and "TW:" .. space or ""
		end

		local function mix_indent()
			local space_pat = [[\v^ +]]
			local tab_pat = [[\v^\t+]]
			local space_indent = vim.fn.search(space_pat, "nwc")
			local tab_indent = vim.fn.search(tab_pat, "nwc")
			local mixed = (space_indent > 0 and tab_indent > 0)
			local mixed_same_line

			if not mixed then
				mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], "nwc")
				mixed = mixed_same_line > 0
			end

			if not mixed then
				return ""
			end

			if mixed_same_line ~= nil and mixed_same_line > 0 then
				return "MI:" .. mixed_same_line
			end

			local space_indent_cnt = vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
			local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total

			if space_indent_cnt > tab_indent_cnt then
				return "MI:" .. tab_indent
			else
				return "MI:" .. space_indent
			end
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = base46.get_lualine_theme("base46", theme),
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				always_divide_middle = true,
				globalstatus = false,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { { "b:gitsigns_head", icon = "" }, { "diff", source = diff_source }, "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat" },
				lualine_y = { "filetype" },
				lualine_z = {
					"location",
					{ trailing_whitespace, color = { bg = colors.red } },
					{ mix_indent, color = { bg = colors.red } },
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "neo-tree", "fugitive" },
		})
	end,
}
