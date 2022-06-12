local cmd = vim.cmd

---            ---
--- Treesitter ---
---            ---
local treesitter_langs = {
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
}

require('nvim-treesitter.configs').setup({
    ensure_installed = treesitter_langs,
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

-- We can enable spell checking for any language that has
-- treesitter since it will only check the comments and not the code
for _, v in ipairs(treesitter_langs) do
    cmd('autocmd FileType ' .. v .. ' setlocal spell spelllang=en_us')
end

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
