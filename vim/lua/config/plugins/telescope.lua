local utils = require("config.utils")
return {
	utils.mirror("telescope.nvim"),
	dependencies = { utils.mirror("plenary.nvim") },
	keys = {
		{ "<leader>f", '<cmd>lua require("telescope.builtin").find_files()<cr>' },
		{ "<leader>r", '<cmd>lua require("telescope.builtin").live_grep()<cr>' },
		{ "<leader>b", '<cmd>lua require("telescope.builtin").buffers()<cr>' },
		{ "<leader>hh", '<cmd>lua require("telescope.builtin").help_tags()<cr>' },
		{ "<leader>n", '<cmd>lua require("telescope.builtin").lsp_references()<cr>' },
		{ "<leader>z", '<cmd>lua require("telescope.builtin").spell_suggest()<cr>' },
	},
	config = function()
		local telescope_actions = require("telescope.actions")
		require("telescope").setup({
			defaults = {
				layout_strategy = "vertical",
				layout_config = {
					vertical = { width = 0.8 },
				},
				mappings = {
					i = {
						["<esc>"] = telescope_actions.close,
						["<c-u>"] = false,
					},
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--trim",
					"--glob",
					"!*.lock",
					"--glob",
					"!*.lockb",
					"--glob",
					"!package-lock.json",
					"--glob",
					"!COPYING",
					"--glob",
					"!LICENSE",
					"--glob",
					"!*.svg",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					find_command = {
						"fd",
						"--type",
						"f",
						"--strip-cwd-prefix",
						-- it's better to include the ignored extensions here since fd will be doing
						-- the filtering instead of Telescope doing it in Lua
						"--exclude",
						"*.png",
						"--exclude",
						"*.jpg",
						"--exclude",
						"*.jpeg",
						"--exclude",
						"*.exe",
						"--exclude",
						"*.ppm",
						"--exclude",
						"*.pdf",
						"--exclude",
						"*.webp",
						"--exclude",
						".git/*",
					},
				},
			},
		})
	end,
}
