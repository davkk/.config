local M = {}

M.lsp_servers = {
    "lua_ls",
    "pyright",
    "marksman",
    "elmls",
    "astro",
    "rust_analyzer",
}

M.mason_packages = {
    "black",
    "prettier",
    "elm-format",
}

M.capabilities = require("cmp_nvim_lsp").default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)

M.setup = function()
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    vim.diagnostic.config({
        severity_sort = true,
        virtual_text = true,
        virtual_lines = false,
        signs = { active = signs },
        underline = true,
        update_in_insert = false,
        float = {
            focusable = false,
            style = 'minimal',
            border = 'rounded',
            source = 'always',
            header = '',
            prefix = '',
        },
    })
end

M.on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, noremap = false, silent = true }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)

    -- open detailed error message window
    vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, opts)

    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

    vim.keymap.set('n', '<leader>fsi', ':FsiShow<CR>', opts)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { focusable = false, border = "rounded" }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
            focusable = false,
            border = "rounded",
        }
    )
end

M.server_setup = function(server, custom_config)
    server.setup(vim.tbl_deep_extend("force", {
        on_attach = M.on_attach,
        capabilities = M.capabilities,
        flags = {
            debounce_text_changes = 100,
        },
    }, custom_config or {}))
end

return M
