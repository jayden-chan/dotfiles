---           ---
--- nvim-tree ---
---           ---
local tree_cb = require("nvim-tree.config").nvim_tree_callback
require("nvim-tree").setup({
	disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	ignore_ft_on_setup = {},
	open_on_tab = false,
	update_to_buf_dir = {
		enable = true,
		auto_open = true,
	},
	hijack_cursor = false,
	update_cwd = false,
	renderer = {
		group_empty = true,
		indent_markers = {
			enable = true,
			icons = {
				corner = "└ ",
				edge = "│ ",
				none = "  ",
			},
		},
		icons = {
			webdev_colors = true,
			git_placement = "before",
		},
	},
	filters = {
		dotfiles = true,
		custom = {
			"^\\.git$",
			"^node_modules$",
			"^dist$",
			"^package-lock\\.json$",
			"^yarn\\.lock$",
			"^target$",
			"^Cargo.lock$",
		},
	},
	update_focused_file = {
		enable = false,
		update_cwd = false,
		ignore_list = {},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	view = {
		width = 35,
		height = 30,
		side = "left",
		auto_resize = false,
		mappings = {
			custom_only = true,
			list = {
				{ key = { "<CR>", "o" }, cb = tree_cb("edit") },
				{ key = "C", cb = tree_cb("cd") },
				{ key = "<C-v>", cb = tree_cb("vsplit") },
				{ key = "s", cb = tree_cb("vsplit") },
				{ key = "<C-x>", cb = tree_cb("split") },
				{ key = "<C-t>", cb = tree_cb("tabnew") },
				{ key = "<", cb = tree_cb("prev_sibling") },
				{ key = ">", cb = tree_cb("next_sibling") },
				{ key = "U", cb = tree_cb("parent_node") },
				{ key = "x", cb = tree_cb("close_node") },
				{ key = "<Tab>", cb = tree_cb("preview") },
				{ key = "J", cb = tree_cb("last_sibling") },
				{ key = "H", cb = tree_cb("toggle_dotfiles") },
				{ key = "r", cb = tree_cb("refresh") },
				{ key = "a", cb = tree_cb("create") },
				{ key = "D", cb = tree_cb("remove") },
				{ key = "R", cb = tree_cb("rename") },
				{ key = "<C-r>", cb = tree_cb("full_rename") },
				{ key = "d", cb = tree_cb("cut") },
				{ key = "c", cb = tree_cb("copy") },
				{ key = "p", cb = tree_cb("paste") },
				{ key = "y", cb = tree_cb("copy_name") },
				{ key = "Y", cb = tree_cb("copy_path") },
				{ key = "gy", cb = tree_cb("copy_absolute_path") },
				{ key = "[c", cb = tree_cb("prev_git_item") },
				{ key = "]c", cb = tree_cb("next_git_item") },
				{ key = "u", cb = tree_cb("dir_up") },
				{ key = "q", cb = tree_cb("close") },
				{ key = "g?", cb = tree_cb("toggle_help") },
			},
		},
	},
})
