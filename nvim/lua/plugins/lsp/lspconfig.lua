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

            [require("typescript-tools")] = {
                settings = { expose_as_code_action = { "all" }, }
            },

            angularls = true,
            astro = true,
            texlab = true,

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

        for server, config in pairs(servers) do
            if not config then
                return
            end

            if type(config) ~= "table" then
                config = {}
            end

            if type(server) == "string" then
                lsp.server_setup(lspconfig[server], config)
            else
                lsp.server_setup(server, config)
            end
        end
    end,
}
