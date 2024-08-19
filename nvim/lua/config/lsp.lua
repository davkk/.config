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

local function try_require(module)
    local ok, result = pcall(require, module)
    return ok and result or nil
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

        local server = try_require('lspconfig.server_configurations.' .. name)
            and require('lspconfig')[name]
            or try_require(name)

        if server then
            server.setup(
                vim.tbl_deep_extend("force", {
                    capabilities = M.client_capabilities(),
                }, config)
            )
        else
            vim.notify(
                string.format("Cannot find server: '%s'", name),
                vim.log.levels.WARN
            )
        end
    end
end

return M
