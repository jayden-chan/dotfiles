---     ---
--- LSP ---
---     ---

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>H', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    local function buf_key(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    buf_key('n', '<leader>o', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_key('n', '<leader>O', '<cmd>vs<CR><cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_key('n', '<leader>g', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_key('n', '<leader>R', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_key('n', '<leader>e', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_key('n', '<leader>F', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    virtual_text = {
        severity = vim.diagnostic.severity.ERROR
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})

---             ---
--- completions ---
---             ---
local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    preselect = cmp.PreselectMode.None,
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol', -- show only symbol annotations
            maxwidth = 60, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        })
    },
    mapping = cmp.mapping.preset.insert({
        -- Enter immediately completes. C-n/C-p to select.
        ['<CR>'] = cmp.mapping.confirm({ select = false })
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
        { name = 'path' },
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' },
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require('lspconfig')

---                       ---
--- Language Server Setup ---
---                       ---
lspconfig.tsserver.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = {
        debounce_text_changes = 150,
    }
})

local prettier = { { formatCommand = 'prettierd "${INPUT}"', formatStdin = true } }

lspconfig.efm.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    init_options = { documentFormatting = true },
    filetypes = {
        'javascript',
        'typescript',
        'javascriptreact',
        'typescriptreact',
        'html',
        'css',
        'scss',
        'less',
        'graphql',
        'markdown',
        'yaml',
        'json',
        'jsonc'
    },
    settings = {
        rootMarkers = { ".git/" },
        languages = {
            javascript = prettier,
            typescript = prettier,
            javascriptreact = prettier,
            typescriptreact = prettier,
            html = prettier,
            css = prettier,
            scss = prettier,
            less = prettier,
            graphql = prettier,
            markdown = prettier,
            yaml = prettier,
            json = prettier,
            jsonc = prettier
        }
    }
})

lspconfig.gopls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    }
})

lspconfig.clangd.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    }
})

lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            completion = {
                postfix = {
                    enable = false,
                },
            },
        },
    }
})

require('lspconfig').sumneko_lua.setup({
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT', },
            diagnostics = { globals = { 'vim' }, },
            workspace = { library = vim.api.nvim_get_runtime_file("", true), },
            telemetry = { enable = false, },
        },
    },
})
