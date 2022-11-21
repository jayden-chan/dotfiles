local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	print("cloning packer...")
	packer_bootstrap = true
	vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

require("packer").startup(function(use)
	local function mirror(name)
		return "https://git.jayden.codes/mirrors/" .. name
	end

	-- Use Packer itself
	use(mirror("packer.nvim"))

	-- Theme
	use(mirror("indent-blankline.nvim"))
	use(mirror("lualine.nvim"))
	-- use(mirror("base46.nvim"))
	use("~/Dev/Personal/base46.nvim")

	-- fs nav
	use(mirror("plenary.nvim"))
	use(mirror("telescope.nvim"))
	use(mirror("nvim-web-devicons"))
	use(mirror("nui.nvim"))
	use({
		mirror("neo-tree.nvim"),
		branch = "v2.x",
	})

	-- Git
	use(mirror("gitsigns.nvim"))
	use(mirror("neogit"))
	use(mirror("vim-fugitive"))

	-- Misc
	use(mirror("tabular"))
	use(mirror("editorconfig-vim"))
	use(mirror("vim-tmux-navigator"))
	use(mirror("vim-repeat"))
	use(mirror("Comment.nvim"))
	use(mirror("nvim-ts-context-commentstring"))
	use(mirror("vim-surround"))
	use(mirror("ultisnips"))
	-- use(mirror("nvim-autopairs"))
	use("cohama/lexima.vim")
	use(mirror("impatient.nvim"))

	-- IDE-like
	use(mirror("nvim-lspconfig"))
	use(mirror("cmp-nvim-lsp"))
	use(mirror("cmp-buffer"))
	use(mirror("cmp-git"))
	use(mirror("cmp-path"))
	use(mirror("cmp-cmdline"))
	use(mirror("nvim-cmp"))
	use(mirror("cmp-nvim-ultisnips"))
	use(mirror("lspkind-nvim"))
	use(mirror("null-ls.nvim"))
	use(mirror("fidget.nvim"))
	use({ mirror("lspsaga.nvim"), branch = "main" })

	-- Syntax
	use({
		{ mirror("nvim-treesitter"), run = ":TSUpdate" },
		{ mirror("nvim-treesitter-textobjects") },
		{ mirror("spellsitter.nvim") },
		{ mirror("playground") },
	})
	use({ mirror("vim-markdown"), ft = { "markdown" } })
	use({ mirror("timing-diagram-generator"), branch = "vim-plugin" })
	use({ mirror("rust.vim"), ft = { "rust" } })
	use({ mirror("vim-hexokinase"), run = "make hexokinase" })
	use({ mirror("nginx.vim"), ft = { "nginx" } })

	if packer_bootstrap then
		require("packer").sync()
	end
end)

pcall(require("impatient"))
