local status, lspconfig = pcall(require, 'lspconfig')
if not status then
    return
end

require('neodev').setup()
require('fidget').setup()

-- server list
local servers = {
    'sumneko_lua',
    'pyright',
}

require("mason").setup()

local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({ ensure_installed = servers })

local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

    vim.keymap.set('n', '<leader>fsi', ':FsiShow<CR>', opts)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { focusable = false }
    )
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    severity_sort = true,
    signs = { active = signs },
    underline = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

local setup = function(server, _config)
    server.setup(vim.tbl_deep_extend("force", {
        autostart = true,
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 100,
        },
        capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    }, _config or {}))
end

-- ionide
setup(require('ionide'), {
    root_dir = function(filename, _)
        local root
        -- in order of preference:
        -- * git repository root
        -- * directory containing a solution file
        -- * directory containing an fsproj file
        -- * directory with fsx scripts
        root = lspconfig.util.find_git_ancestor(filename)
        root = root or lspconfig.util.root_pattern("*.sln")(filename)
        root = root or lspconfig.util.root_pattern("*.fsproj")(filename)
        root = root or lspconfig.util.root_pattern("*.fsx")(filename)
        return root
    end,
    cmd = { "fsautocomplete" },
})

vim.cmd [[
    let g:fsharp#fsi_window_command = 'botright vnew'
    let g:fsharp#lsp_recommended_colorscheme = 0
    let g:fsharp#exclude_project_directories = ['paket-files']
]]

-- lua
setup(lspconfig.sumneko_lua, {
    -- Fix Undefined global 'vim'
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})
