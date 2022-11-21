---            ---
--- auto pairs ---
---            ---
-- require("nvim-autopairs").setup({
-- 	ignored_next_char = "",
-- 	check_ts = true,
-- })

require("Comment").setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
require("fidget").setup()

---        ---
--- neogit ---
---        ---
local neogit = require("neogit")
neogit.setup({
	disable_commit_confirmation = true,
	commit_popup = {
		kind = "vsplit",
	},
})

---               ---
--- gitsigns.nvim ---
---               ---
require("gitsigns").setup({
	signs = {
		add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		untracked = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
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
})

---                  ---
--- indent_blankline ---
---                  ---
require("indent_blankline").setup({
	show_current_context = false,
	show_current_context_start = false,
})

---           ---
--- telescope ---
---           ---
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
