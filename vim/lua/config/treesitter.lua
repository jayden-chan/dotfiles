---            ---
--- Treesitter ---
---            ---
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    "bash",
    "c",
    "cmake",
    "cpp",
    "css",
    "dockerfile",
    "go",
    "graphql",
    "java",
    "javascript",
    "lua",
    "make",
    "python",
    "rust",
    "toml",
    "tsx",
    "typescript",
    "yaml",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
   incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
})
require('spellsitter').setup()
require('nvim-treesitter.configs').setup({
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["hf"] = "@function.inner",
        ["ab"] = "@block.outer",
        ["hb"] = "@block.inner",
      },
    },
  },
})
