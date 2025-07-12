local completion = require("config.completion")

vim.lsp.config("*", {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    flags = {
        debounce_text_changes = 2000,
        allow_incremental_sync = true,
    },
})

vim.lsp.enable({
    "lua_ls",
    "ts_ls",
    "angularls",
    "jsonls",
    "cssls",
    "clangd",
    "ocamllsp",
    "ruff",
    "pyright",
    "gopls",
    "marksman",
    "texlab",
    "zls",
    "tinymist",
    "astro",
})

local callbacks = {
    ts_ls = function(client, buffer)
        vim.keymap.set("n", "<leader>oi", function()
            local params = {
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
                title = "Organize Imports",
            }
            client:exec_cmd(params, { buffer = buffer })
        end, { buffer = buffer, desc = "Organize Imports" })
    end,
    clangd = function(_, buffer)
        vim.keymap.set(
            "n",
            "<leader><tab>",
            vim.cmd.ClangdSwitchSourceHeader,
            { buffer = buffer }
        )
    end,
}

local override_capabilities = {}

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(event)
        local client = assert(
            vim.lsp.get_client_by_id(event.data.client_id),
            "must have valid client"
        )

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf })
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = event.buf })

        completion.setup(client, event.buf)

        local callback = callbacks[client.name]
        if callback ~= nil then
            callback(client, event.buf)
        end

        client.server_capabilities.semanticTokensProvider = nil

        local capabilities = override_capabilities[client.name]
        if capabilities then
            for k, v in pairs(capabilities) do
                if v == vim.NIL then
                    v = nil ---@diagnostic disable-line: cast-local-type
                end
                client.server_capabilities[k] = v
            end
        end
    end,
})
