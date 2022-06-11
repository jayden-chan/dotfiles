---            ---
--- auto pairs ---
---            ---
require('nvim-autopairs').setup({
  ignored_next_char = ""
})

require('Comment').setup()

---        ---
--- neogit ---
---        ---
local neogit = require('neogit')
neogit.setup({
  disable_commit_confirmation = true,
})

---                  ---
--- Discord Presence ---
---                  ---
require('presence'):setup({
    -- General options
    auto_update         = true,
    neovim_image_text   = "extensible Vim-based text editor",
    main_image          = "neovim",
    client_id           = "793271441293967371",
    log_level           = nil,
    debounce_timeout    = 10,
    enable_line_number  = false,
    blacklist           = {},
    buttons             = false,
    file_assets         = {},

    editing_text        = "Editing %s",
    file_explorer_text  = "Browsing file tree",
    git_commit_text     = "Writing a Git commit",
    plugin_manager_text = "Managing plugins",
    reading_text        = "Reading %s",
    workspace_text      = "Working on %s",
    line_number_text    = "Line %s/%s",
})

---               ---
--- gitsigns.nvim ---
---               ---
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>u', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>q', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)

    -- Text object
    map({'o', 'x'}, 'hh', ':<C-U>Gitsigns select_hunk<CR>')
  end
})

---                  ---
--- indent_blankline ---
---                  ---
require('indent_blankline').setup({
    show_current_context = false,
    show_current_context_start = false,
})

---           ---
--- telescope ---
---           ---
require('telescope').setup({
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      vertical = { width = 0.8 }
    },
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close,
      },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown {
        -- even more opts
      }

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    }
  }
})
require('telescope').load_extension('ui-select')
