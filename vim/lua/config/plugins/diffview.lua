local utils = require("config.utils")
return {
	utils.mirror("diffview.nvim"),
	lazy = true,
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	keys = {
		{ "<leader>N", "<cmd>DiffviewOpen<cr>" },
		{ "<leader>M", "<cmd>DiffviewFileHistory<cr>" },
	},
	config = function()
		local actions = require("diffview.actions")
		require("diffview").setup({
			show_help_hints = false,
			file_panel = {
				listing_style = "list",
				win_config = {
					position = "bottom",
					height = 10,
				},
			},
			keymaps = {
				disable_defaults = true,
				view = {
					{ "n", "<leader>b", actions.toggle_files, { desc = "Toggle the file panel." } },
				},
				file_panel = {
					{ "n", "<leader>b", actions.toggle_files, { desc = "Toggle the file panel" } },
					{ "n", "s", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry." } },
					{ "n", "<cr>", actions.select_entry, { desc = "Open the diff for the selected entry." } },
					{ "n", "o", actions.select_entry, { desc = "Open the diff for the selected entry." } },
					{ "n", "<2-LeftMouse>", actions.select_entry, { desc = "Open the diff for the selected entry." } },
					{ "n", "I", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
					{ "n", "K", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
					{ "n", "r", actions.refresh_files, { desc = "Update stats and entries in the file list." } },
					{ "n", "k", actions.select_next_entry, { desc = "Next file entry" } },
					{ "n", "<down>", actions.select_next_entry, { desc = "Next file entry" } },
					{ "n", "i", actions.select_prev_entry, { desc = "Previous file entry." } },
					{ "n", "<up>", actions.select_prev_entry, { desc = "Previous file entry." } },
				},
			},
		})
	end,
}
