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

---@param label string
---@return string
local function format_label(label)
    local limit = vim.o.columns * 0.5
    if #label > limit then
        label = label:sub(1, limit)
        local last_comma = label:match(".*(),")
        if last_comma then
            return label:sub(1, last_comma) .. " …)"
        end
    end
    return label
end

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo" },
    config = function()
        local lspconfig = require("lspconfig")
        local util = require("lspconfig.util")

        local servers = {
            lua_ls = {
                cmd = { vim.env.HOME .. "/.local/share/lua-language-server/bin/lua-language-server" },
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                            disable = { "missing-fields" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false, },
                    },
                },
                override_capabilities = {
                    semanticTokensProvider = vim.NIL
                },
            },

            biome = true,
            ts_ls = {
                callback = function(client, buffer)
                    vim.keymap.set("n", "<leader>oi", function()
                        local params = {
                            command = "_typescript.organizeImports",
                            arguments = { vim.api.nvim_buf_get_name(0) },
                            title = "Organize Imports",
                        }
                        client:exec_cmd(params, { buffer = buffer })
                    end, { buffer = buffer, desc = "Organize Imports" })
                end,
            },
            angularls = { root_dir = util.root_pattern("angular.json", "Gruntfile.js") },
            astro = true,
            jsonls = true,
            cssls = true,

            ocamllsp = {
                settings = {
                    codelens = { enable = true },
                    extendedHover = { enable = true },
                    inlayHints = { enable = true },
                    syntaxDocumentation = { enable = true },
                },
            },

            pyright = {
                root_dir = util.root_pattern("pyproject.toml"),
                settings = {
                    python = {
                        analysis = { typeCheckingMode = "standard" }
                    }
                }
            },

            gopls = true,

            neocmake = {
                init_options = {
                    scan_cmake_in_package = false,
                    semantic_token = true,
                }
            },
            clangd = {
                cmd = {
                    "clangd",
                    "-j=3",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--cross-file-rename",
                },
                single_file_support = false,
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
                callback = function(_, buffer)
                    vim.keymap.set("n", "<leader><tab>", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = buffer })
                end,
            },

            marksman = true,
            texlab = true,

            jdtls = {
                cmd = { vim.env.HOME .. "/.local/share/jdtls/bin/jdtls" },
            },

            zls = true,
        }

        local capabilities = vim.lsp.protocol.make_client_capabilities()

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
            lspconfig[name].setup(
                vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                }, config)
            )
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(event)
                local client = assert(vim.lsp.get_client_by_id(event.data.client_id), "must have valid client")
                local settings = servers[client.name]
                if type(settings) ~= "table" then
                    settings = {}
                end

                if client.server_capabilities.completionProvider then
                    vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
                end
                if client.server_capabilities.definitionProvider then
                    vim.opt_local.tagfunc = "v:lua.vim.lsp.tagfunc"
                end

                if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
                    vim.lsp.completion.enable(true, client.id, event.buf, {
                        autotrigger = true,
                        convert = function(item)
                            return {
                                abbr = format_label(item.label),
                                kind = item_kind_map[item.kind],
                                menu = ""
                            }
                        end
                    })
                end

                vim.keymap.set({ "i", "x" }, "<C-n>", function()
                    if tonumber(vim.fn.pumvisible()) ~= 0 then
                        return "<C-n>"
                    else
                        if next(vim.lsp.get_clients { bufnr = 0 }) then
                            vim.lsp.completion.trigger()
                        else
                            return vim.bo.omnifunc == "" and "<C-x><C-n>" or "<C-x><C-o>"
                        end
                    end
                end, { buffer = event.buf, expr = true, remap = true })

                vim.keymap.set({ "i", "x" }, "<C-c>", function()
                    return tonumber(vim.fn.pumvisible()) ~= 0 and "<C-e>" or "<C-c>"
                end, { buffer = event.buf, expr = true })

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf })
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = event.buf })

                -- set server-specific attach
                if settings.callback then
                    settings.callback(client, event.buf)
                end

                -- override server capabilities
                if settings.override_capabilities then
                    for k, v in pairs(settings.override_capabilities) do
                        if v == vim.NIL then
                            v = nil
                        end
                        client.server_capabilities[k] = v
                    end
                end
            end,
        })

        vim.diagnostic.config({
            severity_sort = true,
            virtual_text = true,
            underline = true,
            update_in_insert = false,
            float = {
                source = true,
                show_header = true,
                style = "minimal",
                header = "",
                prefix = "",
                border = "solid",
            },
        })
    end,
}
