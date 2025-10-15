vim.lsp.config("*", {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    flags = {
        debounce_text_changes = 2000,
        allow_incremental_sync = true,
    },
})

vim.lsp.enable {
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
}

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
        vim.keymap.set("n", "<leader><tab>", vim.cmd.ClangdSwitchSourceHeader, { buffer = buffer })
    end,
}

local override_capabilities = {}

local item_kind_map = {
    [1] = "Text",
    [2] = "Method",
    [3] = "Function",
    [4] = "Constructor",
    [5] = "Field",
    [6] = "Variable",
    [7] = "Class",
    [8] = "Interface",
    [9] = "Module",
    [10] = "Property",
    [11] = "Unit",
    [12] = "Value",
    [13] = "Enum",
    [14] = "Keyword",
    [15] = "Snippet",
    [16] = "Color",
    [17] = "File",
    [18] = "Reference",
    [19] = "Folder",
    [20] = "EnumMember",
    [21] = "Constant",
    [22] = "Struct",
    [23] = "Event",
    [24] = "Operator",
    [25] = "TypeParameter",
}

local utils = require "core.utils"

---@param item lsp.CompletionItem
---@return table
local function convert(item)
    local limit = vim.o.columns * 0.4
    local label = item.label
    if #label > limit then
        label = label:sub(1, limit)
        local last_comma = label:match ".*(),"
        if last_comma then
            label = label:sub(1, last_comma) .. " …)"
        end
    end
    return {
        abbr = label,
        kind = item.kind and item_kind_map[item.kind] or 1,
        menu = item.detail and utils.shorten_path(item.detail, 15) or "",
    }
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user.lspconfig", {}),
    callback = function(event)
        local client = assert(vim.lsp.get_client_by_id(event.data.client_id), "must have valid client")

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf })
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = event.buf })

        if client.server_capabilities.completionProvider then
            vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
        end
        if client.server_capabilities.definitionProvider then
            vim.opt_local.tagfunc = "v:lua.vim.lsp.tagfunc"
        end

        if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
            vim.lsp.completion.enable(true, client.id, event.buf, {
                autotrigger = true,
                convert = convert,
            })
        end

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
