local utils = require("config.utils")
return {
	utils.mirror("fzf-lua"),
	dependencies = { utils.mirror("nvim-web-devicons") },
	keys = {
		{ "<leader>f", '<cmd>lua require("fzf-lua").files({ winopts = { preview = { vertical = "up:30%" } } })<cr>' },
		{ "<leader>r", '<cmd>lua require("fzf-lua").live_grep()<cr>' },
		{ "<leader>n", '<cmd>lua require("fzf-lua").lsp_references()<cr>' },
		{ "<leader>z", '<cmd>lua require("fzf-lua").spell_suggest()<cr>' },
	},
	opts = {
		winopts = {
			fullscreen = true,
			preview = {
				layout = "vertical",
				vertical = "up:60%",
				title = false,
				scrollbar = false,
			},
		},
		files = {
			cmd = "fd"
				.. " --color=never"
				.. " --hidden"
				.. " --type file"
				.. " --type symlink"
				.. " --exclude .git"
				.. " --exclude '*.png'"
				.. " --exclude '*.jpg'"
				.. " --exclude '*.jpeg'"
				.. " --exclude '*.exe'"
				.. " --exclude '*.ppm'"
				.. " --exclude '*.pdf'"
				.. " --exclude '*.webp'"
				.. " --exclude '*.patch'"
				.. " --exclude '*.lockb'"
				.. " --exclude '*.lock'",
		},
		grep = {
			cmd = "rg --vimgrep"
				.. " --column"
				.. " --line-number"
				.. " --no-heading"
				.. " --color=always"
				.. " --smart-case"
				.. " --max-columns=4096"
				.. " --glob '!*.patch'"
				.. " --glob '!*.lock'"
				.. " --glob '!*.lockb'"
				.. " --glob '!package-lock.json'"
				.. " --glob '!COPYING'"
				.. " --glob '!LICENSE'"
				.. " --glob '!*.svg'"
				.. " --regexp",
		},
	},
}
