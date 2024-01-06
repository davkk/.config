local M = {}

function M.on_attach(client, bufnr)
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

    if client.supports_method("textDocument/codeLens") then
        vim.lsp.codelens.refresh()

        local refreshCodelens = vim.api.nvim_create_augroup("refreshCodelens", {})

        vim.api.nvim_create_autocmd(
            { "BufEnter", "InsertLeave", "TextChanged", },
            {
                buffer = bufnr,
                callback = vim.lsp.codelens.refresh,
                group = refreshCodelens,
            })
    end

    if filetype == "typescript" or filetype == "lua" then
        client.server_capabilities.semanticTokensProvider = nil
    end

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { focusable = false }
    )
end

M.capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
)

M.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}
M.capabilities.textDocument.completion.completionItem.insertReplaceSupport = false
M.capabilities.textDocument.codeLens = { dynamicRegistration = false }

function M.server_setup(server, custom_config)
    server.setup(vim.tbl_deep_extend("force", {
        on_attach = M.on_attach,
        capabilities = M.capabilities,
        flags = { debounce_text_changes = 100 },
    }, custom_config or {}))
end

return M
