local utils = require("config.utils")
return {
	utils.mirror("gitsigns.nvim"),
	opts = {
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "▁" },
			topdelete = { text = "▔" },
			changedelete = { text = "~" },
			untracked = { text = "┃" },
		},
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true })

			map("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true })

			-- Actions
			map({ "n", "v" }, "<leader>u", ":Gitsigns reset_hunk<CR>")
			map("n", "<leader>hR", gs.reset_buffer)
			map("n", "<leader>q", gs.preview_hunk)
			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end)
			map("n", "<leader>tb", gs.toggle_current_line_blame)

			-- Text object
			map({ "o", "x" }, "hh", ":<C-U>Gitsigns select_hunk<CR>")
		end,
	},
}
