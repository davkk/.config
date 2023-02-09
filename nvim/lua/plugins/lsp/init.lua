return {
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason-lspconfig.nvim",

            "j-hui/fidget.nvim",
            "folke/neodev.nvim",

            {
                "ionide/Ionide-vim", -- F# support
                config = function()
                    vim.cmd [[
                        let g:fsharp#fsi_window_command = 'botright vnew'
                        let g:fsharp#lsp_recommended_colorscheme = 0
                        let g:fsharp#exclude_project_directories = ['paket-files']
                    ]]
                end
            },
            -- "adelarsq/neofsharp.vim",
        },
        config = function()
            local utils = require("plugins.lsp.utils")
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")

            utils.setup()

            mason_lspconfig.setup({
                ensure_installed = utils.lsp_servers,
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    utils.server_setup(lspconfig[server_name])
                end,
                ["sumneko_lua"] = function()
                    utils.server_setup(lspconfig.sumneko_lua, {
                        -- Fix Undefined global 'vim'
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { 'vim' }
                                }
                            }
                        }
                    })
                end,
                ["elmls"] = function()
                    utils.server_setup(lspconfig.elmls, {
                        root_dir = lspconfig.util.root_pattern("elm.json")
                    })
                end
            })

            utils.server_setup(require("ionide"), {
                root_dir = function(filename, _)
                    local root
                    root = lspconfig.util.find_git_ancestor(filename)
                    root = root or lspconfig.util.root_pattern("*.sln")(filename)
                    root = root or lspconfig.util.root_pattern("*.fsproj")(filename)
                    root = root or lspconfig.util.root_pattern("*.fsx")(filename)
                    return root
                end,
                cmd = { "fsautocomplete" },
            })
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = {
            pip = {
                upgrade_pip = true,
            },
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)

            local utils = require("plugins.lsp.utils")
            local registry = require("mason-registry")

            for _, package in ipairs(utils.mason_packages) do
                local result = registry.get_package(package)
                if not result:is_installed() then
                    result:install()
                end
            end
        end,
    },
}
