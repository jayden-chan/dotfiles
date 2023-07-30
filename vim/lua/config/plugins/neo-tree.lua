local utils = require("config.utils")
return {
	utils.mirror("neo-tree.nvim"),
	branch = "v3.x",
	dependencies = {
		utils.mirror("nui.nvim"),
		utils.mirror("plenary.nvim"),
		utils.mirror("nvim-web-devicons"),
	},
	keys = {
		{ "<C-n>", "<cmd>Neotree toggle<CR>" },
	},
	config = function()
		vim.g.neo_tree_remove_legacy_commands = 1
		require("neo-tree").setup({
			close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			sort_case_insensitive = false, -- used when sorting files and directories in the tree
			sort_function = nil, -- use a custom function for sorting files and directories in the tree
			default_component_configs = {
				container = {
					enable_character_fade = true,
				},
				indent = {
					indent_size = 2,
					padding = 1, -- extra padding on left hand side
					-- indent guides
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
					-- expander config, needed for nesting files
					with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "ﰊ",
					-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
					-- then these will never be used.
					default = "*",
					highlight = "NeoTreeFileIcon",
				},
				modified = {
					symbol = "[+]",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = true,
					highlight = "NeoTreeFileName",
				},
				git_status = {
					symbols = {
						-- Change type
						added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
						modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
						deleted = "✖", -- this can only be used in the git_status source
						renamed = "", -- this can only be used in the git_status source
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "",
						staged = "",
						conflict = "",
					},
				},
			},
			window = {
				position = "left",
				width = 35,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["o"] = function(state)
						local node = state.tree:get_node()
						if require("neo-tree.utils").is_expandable(node) then
							state.commands["toggle_node"](state)
						else
							state.commands["open"](state)
						end
					end,
					["S"] = "open_split",
					["s"] = "open_vsplit",
					["t"] = "open_tabnew",
					["w"] = "open_with_window_picker",
					["z"] = "close_all_nodes",
					["a"] = {
						"add",
						-- some commands may take optional config options, see `:h neo-tree-mappings` for details
						config = {
							show_path = "none", -- "none", "relative", "absolute"
						},
					},
					["A"] = "add_directory", -- also accepts the optional config.show_path option like "add".
					["D"] = "delete",
					["R"] = "rename",
					["c"] = "copy_to_clipboard",
					["X"] = "cut_to_clipboard",
					["x"] = "close_node",
					["p"] = "paste_from_clipboard",
					["y"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
					["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
					["q"] = "close_window",
					["r"] = "refresh",
					["?"] = "show_help",
					["<"] = "prev_source",
					[">"] = "next_source",
				},
			},
			nesting_rules = {},
			filesystem = {
				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					force_visible_in_empty_folder = true, -- when true, hidden files will be shown if the root folder is otherwise empty
					show_hidden_count = false, -- when true, the number of hidden items in each folder will be shown as the last entry
					hide_dotfiles = true,
					hide_gitignored = true,
					hide_hidden = true, -- only works on Windows for hidden files/directories
					hide_by_name = {
						"node_modules",
						"target",
					},
					hide_by_pattern = { -- uses glob style patterns
						"*.swp",
						"*.bin",
						"*.exe",
						"*.lock",
					},
					always_show = { -- remains visible even if other settings would normally hide it
						".gitignore",
					},
					never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
						".DS_Store",
						".git",
					},
				},
				follow_current_file = {
					enabled = false,
				}, -- This will find and focus the file in the active buffer every
				-- time the current file is changed while the tree is open.
				group_empty_dirs = true, -- when true, empty folders will be grouped together
				hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
				-- in whatever position is specified in window.position
				-- "open_current",  -- netrw disabled, opening a directory opens within the
				-- window like netrw would, regardless of window.position
				-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
				use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
				-- instead of relying on nvim autocmd events.
				window = {
					mappings = {
						["u"] = "navigate_up",
						["C"] = "set_root",
						["H"] = "toggle_hidden",
						["/"] = "fuzzy_finder",
						["f"] = "filter_on_submit",
						["<c-x>"] = "clear_filter",
						["[g"] = "prev_git_modified",
						["]g"] = "next_git_modified",
					},
				},
			},
			buffers = {
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every
				},
				-- time the current file is changed while the tree is open.
				group_empty_dirs = true, -- when true, empty folders will be grouped together
				show_unloaded = true,
				window = {
					mappings = {
						["bd"] = "buffer_delete",
						["<bs>"] = "navigate_up",
						["."] = "set_root",
					},
				},
			},
			git_status = {
				window = {
					position = "float",
					mappings = {
						["A"] = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
					},
				},
			},
		})
	end,
}
