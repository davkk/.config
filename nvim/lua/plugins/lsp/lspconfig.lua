local ensure_lsp_servers = {
    "lua_ls",
    "jsonls",
    "marksman",
    "cssls",
}

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",

        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local lspconfig = require("lspconfig")
        local lsp = require("davkk.lsp")

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

        mason.setup()
        mason_lspconfig.setup({
            ensure_installed = ensure_lsp_servers,
            handlers = {
                function(server_name)
                    print(server_name)
                    lsp.server_setup(lspconfig[server_name])
                end,
                ["lua_ls"] = function()
                    lsp.server_setup(lspconfig.lua_ls, {
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
                    })
                end,
                ["pyright"] = function()
                    lsp.server_setup(lspconfig.pyright, {
                        root_dir = lspconfig.util.root_pattern("pyproject.toml"),
                        settings = {
                            python = {
                                analysis = { typeCheckingMode = "standard" }
                            }
                        }
                    })
                end,
                ["cssls"] = function()
                    lsp.server_setup(lspconfig.cssls, {
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
                end,
            }
        })

        lsp.server_setup(lspconfig.ocamllsp, {
            settings = {
                codelens = { enable = true },
                extendedHover = { enable = true },
            },
        })
    end,
}
