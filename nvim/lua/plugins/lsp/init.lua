return {
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason-lspconfig.nvim",

            {
                "ErichDonGubler/lsp_lines.nvim",
                config = function()
                    require("lsp_lines").setup()

                    vim.keymap.set("n", "<leader>e", function()
                        vim.diagnostic.config({
                            virtual_text = not vim.diagnostic.config().virtual_text,
                            virtual_lines = not vim.diagnostic.config().virtual_lines,
                        })
                    end)
                end,
            },

            {
                "j-hui/fidget.nvim",
                opts = {
                    text = {
                        spinner = "line",
                        done = "",
                    },
                    window = {
                        blend = 0,
                        zindex = 100,
                        border = "rounded", -- style of border for the fidget window
                    },
                },
                config = function(_, opts)
                    require("fidget").setup(opts)
                end
            },
            {
                "folke/neodev.nvim",
                config = true
            },

            "ionide/Ionide-vim", -- F# support
            -- "adelarsq/neofsharp.vim",

            "simrat39/rust-tools.nvim",
        },
        config = function()
            local utils = require("plugins.lsp.utils")
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")

            utils.setup()

            require("lspconfig.ui.windows").default_options.border = "rounded"

            mason_lspconfig.setup({
                ensure_installed = utils.lsp_servers,
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    utils.server_setup(lspconfig[server_name])
                end,
                ["lua_ls"] = function()
                    utils.server_setup(lspconfig.lua_ls, {
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
                end,
                ["tailwindcss"] = function()
                    utils.server_setup(lspconfig.tailwindcss, {
                        filetypes = { "elm", "astro", "astro-markdown", "html", "jade", "markdown", "mdx",
                            "css", "less", "postcss", "sass", "scss", "stylus", "javascript", "javascriptreact",
                            "rescript", "typescript", "typescriptreact", },
                    })
                end,
            })

            require("rust-tools").setup({
                server = {
                    on_attach = utils.on_attach,
                    capabilities = utils.capabilities,
                    flags = {
                        debounce_text_changes = 100,
                    },
                    cmd = {
                        "rustup", "run", "stable", "rust-analyzer"
                    },
                    imports = {
                        prefix = "crate",
                    },
                    cargo = {
                        features = "all",
                    },
                    check = {
                        command = "clippy",
                    },
                    diagnostics = {
                        enable = true,
                    },
                }
            })

            utils.server_setup(require("ionide"), {
                cmd = {
                    "fsautocomplete",
                    "--project-graph-enabled",
                    "--adaptive-lsp-server-enabled",
                },
                root_dir = function(filename, _)
                    local root
                    root = lspconfig.util.find_git_ancestor(filename)
                    root = root or lspconfig.util.root_pattern("*.sln")(filename)
                    root = root or lspconfig.util.root_pattern("*.fsproj")(filename)
                    root = root or lspconfig.util.root_pattern("*.fsx")(filename)
                    return root
                end,
            })

            vim.cmd [[
                let g:fsharp#fsi_window_command = "botright vnew | lcd #:p:h"
                let g:fsharp#lsp_recommended_colorscheme = 0
                let g:fsharp#exclude_project_directories = ['paket-files']
                let g:fsharp#recommended_colorscheme = 0
            ]]

            -- change filetype of fsproj files
            vim.api.nvim_create_autocmd(
                { "BufNewFile", "BufRead" },
                {
                    command = "set ft=xml",
                    pattern = { "*.fsproj" },
                    group = vim.api.nvim_create_augroup("fsprojFtdetect", { clear = true })
                })

            -- change cwd on open .fsx files
            vim.api.nvim_create_autocmd(
                { "BufEnter", "TermOpen" },
                {
                    command = "lcd %:p:h",
                    pattern = { "*.fsx" },
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
