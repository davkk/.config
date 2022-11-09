local status, lspconfig = pcall(require, 'lspconfig')
if not status then
    return
end

-- server list
local servers = {}


local on_attach  = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- Mappings
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    buf_set_keymap('n', '<leader>fsi', ':FsiShow<CR>', opts)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { focusable = false }
    )
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local setup = function(server, _config)
    server.setup(vim.tbl_deep_extend("force", {
        autostart = true,
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 100,
        },
        capabilities = capabilities,
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
