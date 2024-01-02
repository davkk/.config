local ensure_lsp_servers = {
    "lua_ls",
    "marksman",
    "cssls",
}

local function create_codelens_autocmd(client, bufnr)
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
end

local function setup_lsp_handlers()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {}
    )
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { focusable = false }
    )
end

local function setup_vim_diagnostics()
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
        },
    })
end

local updated_capabilities = vim.tbl_deep_extend("force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities())

updated_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
updated_capabilities.textDocument.completion.completionItem.documentationFormat = {
    "markdown",
    "plaintext"
}
updated_capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false
updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }

local function on_attach(client, bufnr)
    create_codelens_autocmd(client, bufnr)
    setup_lsp_handlers()
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(
    updated_capabilities)

local function server_setup(server, custom_config)
    server.setup(vim.tbl_deep_extend("force", {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = { debounce_text_changes = 100 },
    }, custom_config or {}))
end

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",

            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            "ionide/Ionide-vim",
            "pmizio/typescript-tools.nvim"
        },
        config = function()
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")

            setup_vim_diagnostics()

            mason.setup()
            mason_lspconfig.setup({
                ensure_installed = ensure_lsp_servers,
                handlers = {
                    function(server_name)
                        server_setup(lspconfig[server_name])
                    end,
                }
            })

            server_setup(lspconfig.lua_ls, {
                settings = {
                    Lua = {
                        format = {
                            enable = true,
                            defaultConfig = { max_line_length = "80", }
                        },
                        diagnostics = { globals = { "vim" }, },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false, },
                    },
                }
            })

            server_setup(lspconfig.pyright, {
                root_dir = lspconfig.util.root_pattern("pyproject.toml"),
                settings = {
                    python = { analysis = { typeCheckingMode = "standard" } }
                }
            })

            server_setup(lspconfig.cssls, {
                settings = {
                    css = {
                        validate = true,
                        lint = { unknownAtRules = "ignore" }
                    },
                    scss = {
                        validate = true,
                        lint = { unknownAtRules = "ignore" }
                    },
                    less = {
                        validate = true,
                        lint = { unknownAtRules = "ignore" }
                    },
                },
            })

            server_setup(lspconfig.ocamllsp, {
                settings = {
                    codelens = { enable = true },
                    extendedHover = { enable = true },
                },
            })

            server_setup(require("typescript-tools"), {
                settings = {
                    expose_as_code_action = { "all" },
                    code_lens = "all",
                }
            })

            server_setup(require("ionide"), {
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
            })
        end,
    },

    {
        "j-hui/fidget.nvim",
        event = { "BufReadPost", "BufNewFile" },
        branch = "legacy",
        opts = {
            text = {
                spinner = "line",
                done = "",
            },
            timer = {
                spinner_rate = 200,  -- frame rate of spinner animation, in ms
                fidget_decay = 1000, -- how long to keep around empty fidget, in ms
                task_decay = 700,    -- how long to keep around completed task, in ms
            },
            window = {
                relative = "editor",
                blend = 0,
                zindex = 100,
            },
        },
    },
}
