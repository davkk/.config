local M = {}

M.lsp_servers = {
    "lua_ls",
    "pyright",
    "marksman",
    "astro",
    "pyright",
    "tsserver",
    "angularls",
}

local c = vim.lsp.protocol.make_client_capabilities()
c.textDocument.completion.completionItem.snippetSupport = true
c.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}

M.capabilities = require("cmp_nvim_lsp").default_capabilities(c)

M.signs = {
    Error ="E ",
    Warn = "W ",
    Hint = "H ",
    Info = "I ",
}

M.setup = function()
    for type, icon in pairs(M.signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    vim.diagnostic.config({
        severity_sort = true,
        virtual_text = true,
        virtual_lines = false,
        signs = { active = M.signs },
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

M.create_codelens_autocmd = function(client, bufnr)
    if client.supports_method("textDocument/codeLens") then
        vim.lsp.codelens.refresh()

        local refreshCodelens = vim.api.nvim_create_augroup("refreshCodelens", {})

        vim.api.nvim_create_autocmd({
            "BufEnter",
            "InsertLeave",
            "TextChanged",
        }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
            group = refreshCodelens,
        })
    end
end

M.setup_lsp_keybinds = function(bufnr)
    local opts = { buffer = bufnr, noremap = false, silent = true }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)

    -- open detailed error message window
    vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, opts)

    vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)

    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    vim.keymap.set("i", "<C-h>",
        function()
            require("cmp").mapping.abort()
            vim.lsp.buf.signature_help()
        end,
        opts)
end


M.setup_lsp_handlers = function()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = "rounded" }
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
        on_attach = function(client, bufnr)
            M.setup_lsp_keybinds(bufnr)
            M.create_codelens_autocmd(client, bufnr)
            M.setup_lsp_handlers()
        end,
        capabilities = M.capabilities,
        flags = {
            debounce_text_changes = 100,
        },
    }, custom_config or {}))
end

return M
