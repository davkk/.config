local M = {}

function M.client_capabilities()
    local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
    )

    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

    capabilities.textDocument.codeLens = {
        dynamicRegistration = false
    }

    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }

    return capabilities
end

function M.setup_servers(servers)
    for name, config in pairs(servers) do
        if not config then
            return
        end
        if type(config) == "function" then
            config = config()
        end
        if type(config) ~= "table" then
            config = {}
        end

        local ok, _ = pcall(require, 'lspconfig.server_configurations.' .. name)
        local server = ok and require("lspconfig")[name] or require(name)
        server.setup(
            vim.tbl_deep_extend("force", {
                capabilities = M.client_capabilities(),
            }, config or {})
        )
    end
end

return M
