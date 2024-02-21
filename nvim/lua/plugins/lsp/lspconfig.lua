local function on_attach(client, bufnr)
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

    if client.supports_method("textDocument/codeLens") then
        vim.lsp.codelens.refresh()
        vim.api.nvim_create_autocmd(
            { "BufEnter", "InsertLeave", "TextChanged", },
            {
                buffer = bufnr,
                callback = vim.lsp.codelens.refresh,
                group = vim.api.nvim_create_augroup("refreshCodelens", {}),
            }
        )
    end

    if filetype == "lua" then
        client.server_capabilities.semanticTokensProvider = nil
    end

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { focusable = false }
    )
end

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "Mason" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",

        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        { "pmizio/typescript-tools.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local lspconfig = require("lspconfig")

        vim.diagnostic.config({
            severity_sort = true,
            virtual_text = true,
            underline = true,
            update_in_insert = false,
            float = {
                show_header = true,
                style = "minimal",
                header = "",
                prefix = "",
                border = "solid",
            },
        })

        mason.setup()
        mason_lspconfig.setup({
            ensure_installed = { "lua_ls", "jsonls", "marksman", "cssls" },
        })

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" }, },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false, },
                    },
                }
            },
            jsonls = true,
            marksman = true,
            cssls = true,

            ocamllsp = {
                settings = {
                    codelens = { enable = true },
                    extendedHover = { enable = true },
                },
            },
            pyright = {
                root_dir = lspconfig.util.root_pattern("pyproject.toml"),
                settings = {
                    python = {
                        analysis = { typeCheckingMode = "standard" }
                    }
                }
            },
            gopls = true,
            clangd = true,

            [require("typescript-tools")] = function()
                vim.keymap.set("n", "<leader>oi", ":TSToolsOrganizeImports<cr>", { silent = true })
            end,

            angularls = {
                root_dir = lspconfig.util.root_pattern("angular.json", "Gruntfile.js"),
            }
            ,
            astro = true,
            texlab = true,

            r_language_server = true,

            fsharp_language_server = {
                cmd = {
                    "fsautocomplete",
                    "--project-graph-enabled",
                    "--adaptive-lsp-server-enabled",
                },
                root_dir = function(filename, _)
                    local root
                    root = lspconfig.util.find_git_ancestor(filename)
                    root = root or lspconfig.util.root_pattern("*.sln")(filename)
                    root = root or
                        lspconfig.util.root_pattern("*.fsproj")(filename)
                    root = root or lspconfig.util.root_pattern("*.fsx")(filename)
                    return root
                end,
            },
        }

        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities()
        )

        capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        }
        capabilities.textDocument.completion.completionItem.insertReplaceSupport = false
        capabilities.textDocument.codeLens = { dynamicRegistration = false }

        for server, config in pairs(servers) do
            if not config then
                return
            end

            if type(config) == "function" then
                config = config()
            end

            if type(config) ~= "table" then
                config = {}
            end

            (type(server) == "string" and lspconfig[server] or server)
                .setup(vim.tbl_deep_extend("force", {
                    on_attach = on_attach,
                    capabilities = capabilities,
                    flags = { debounce_text_changes = 100 },
                }, config or {}))
        end
    end,
}
