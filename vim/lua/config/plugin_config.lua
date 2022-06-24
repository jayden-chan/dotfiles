---            ---
--- auto pairs ---
---            ---
require("nvim-autopairs").setup({
	ignored_next_char = "",
	check_ts = true,
})

require("Comment").setup()
require("fidget").setup()

local actions = require("diffview.actions")
require("diffview").setup({
	diff_binaries = false, -- Show diffs for binaries
	enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
	use_icons = true, -- Requires nvim-web-devicons
	icons = { -- Only applies when use_icons is true.
		folder_closed = "",
		folder_open = "",
	},
	signs = {
		fold_closed = "",
		fold_open = "",
	},
	file_panel = {
		listing_style = "tree", -- One of 'list' or 'tree'
		tree_options = { -- Only applies when listing_style is 'tree'
			flatten_dirs = true, -- Flatten dirs that only contain one single dir
			folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
		},
		win_config = { -- See ':h diffview-config-win_config'
			position = "bottom",
			height = 10,
		},
	},
	file_history_panel = {
		log_options = { -- See ':h diffview-config-log_options'
			single_file = {
				diff_merges = "combined",
			},
			multi_file = {
				diff_merges = "first-parent",
			},
		},
		win_config = { -- See ':h diffview-config-win_config'
			position = "bottom",
			height = 16,
		},
	},
	commit_log_panel = {
		win_config = {}, -- See ':h diffview-config-win_config'
	},
	default_args = { -- Default args prepended to the arg-list for the listed commands
		DiffviewOpen = {},
		DiffviewFileHistory = {},
	},
	hooks = {}, -- See ':h diffview-config-hooks'
	keymaps = {
		disable_defaults = false, -- Disable the default keymaps
		view = {
			["<tab>"] = actions.select_next_entry, -- Open the diff for the next file
		},
		file_panel = {
			["k"] = actions.next_entry, -- Bring the cursor to the next file entry
			["<down>"] = actions.next_entry,
			["i"] = actions.prev_entry, -- Bring the cursor to the previous file entry.
			["<up>"] = actions.prev_entry,
			["<cr>"] = actions.select_entry, -- Open the diff for the selected entry.
			["o"] = actions.select_entry,
			["<2-LeftMouse>"] = actions.select_entry,
			["s"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
			["S"] = actions.stage_all, -- Stage all entries.
			["U"] = actions.unstage_all, -- Unstage all entries.
			["X"] = actions.restore_entry, -- Restore entry to the state on the left side.
			["R"] = actions.refresh_files, -- Update stats and entries in the file list.
			["L"] = actions.open_commit_log, -- Open the commit log panel.
			["<tab>"] = actions.select_next_entry,
			["<s-tab>"] = actions.select_prev_entry,
			["gf"] = actions.goto_file,
			["<C-w><C-f>"] = actions.goto_file_split,
			["<C-w>gf"] = actions.goto_file_tab,
			["f"] = actions.toggle_flatten_dirs, -- Flatten empty subdirectories in tree listing style.
		},
		file_history_panel = {
			["g!"] = actions.options, -- Open the option panel
			["<C-A-d>"] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
			["y"] = actions.copy_hash, -- Copy the commit hash of the entry under the cursor
			["L"] = actions.open_commit_log,
			["zR"] = actions.open_all_folds,
			["zM"] = actions.close_all_folds,
			["k"] = actions.next_entry,
			["<down>"] = actions.next_entry,
			["i"] = actions.prev_entry,
			["<up>"] = actions.prev_entry,
			["<cr>"] = actions.select_entry,
			["o"] = actions.select_entry,
			["<2-LeftMouse>"] = actions.select_entry,
			["<tab>"] = actions.select_next_entry,
			["<s-tab>"] = actions.select_prev_entry,
			["gf"] = actions.goto_file,
			["<C-w><C-f>"] = actions.goto_file_split,
			["<C-w>gf"] = actions.goto_file_tab,
			["<leader>e"] = actions.focus_files,
			["<leader>b"] = actions.toggle_files,
		},
		option_panel = {
			["<tab>"] = actions.select_entry,
			["q"] = actions.close,
		},
	},
})

---        ---
--- neogit ---
---        ---
local neogit = require("neogit")
neogit.setup({
	disable_commit_confirmation = true,
	integrations = {
		diffview = true,
	},
	commit_popup = {
		kind = "vsplit",
	},
})

---               ---
--- gitsigns.nvim ---
---               ---
require("gitsigns").setup({
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
require("telescope").setup({
	defaults = {
		layout_strategy = "vertical",
		layout_config = {
			vertical = { width = 0.8 },
		},
		mappings = {
			i = {
				["<esc>"] = require("telescope.actions").close,
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
