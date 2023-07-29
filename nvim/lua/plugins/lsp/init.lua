return {
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        config = function()
            local utils = require("plugins.lsp.utils")

            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")

            utils.setup()

            require("lspconfig.ui.windows").default_options.border = "rounded"

            mason.setup({
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
            })

            mason_lspconfig.setup({
                ensure_installed = utils.lsp_servers,
                handlers = {
                    function(server_name)
                        utils.server_setup(lspconfig[server_name])
                    end,
                }
            })

            utils.server_setup(lspconfig.lua_ls, {
                -- Fix Undefined global 'vim'
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file('', true),
                            checkThirdParty = false, -- THIS IS THE IMPORTANT LINE TO ADD
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                }
            })

            utils.server_setup(lspconfig.pyright, {
                root_dir = lspconfig.util.root_pattern("pyproject.toml"),
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "off"
                        }
                    }
                }
            })

            utils.server_setup(lspconfig.tailwindcss, {
                filetypes = { "elm", "astro", "astro-markdown", "html", "jade", "markdown", "mdx",
                    "css", "less", "postcss", "sass", "scss", "stylus", "javascript", "javascriptreact",
                    "rescript", "typescript", "typescriptreact", },
            })

            utils.server_setup(lspconfig.cssls, {
                settings = {
                    css = {
                        validate = true,
                        lint = {
                            unknownAtRules = "ignore"
                        }
                    },
                    scss = {
                        validate = true,
                        lint = {
                            unknownAtRules = "ignore"
                        }
                    },
                    less = {
                        validate = true,
                        lint = {
                            unknownAtRules = "ignore"
                        }
                    },
                },
            })

            utils.server_setup(lspconfig.ocamllsp)

            require("rust-tools").setup({
                tools = {
                    hover_actions = {
                        max_width = 50,
                    },
                    inlay_hints = {
                        auto = true,
                        show_parameter_hints = false,
                        parameter_hints_prefix = "// ",
                        other_hints_prefix = "// ",
                    },
                },
                server = {
                    on_attach = utils.on_attach,
                    capabilities = utils.capabilities,
                    flags = {
                        debounce_text_changes = 100,
                    },
                    cmd = {
                        "rustup", "run", "stable", "rust-analyzer"
                    },
                    settings = {
                        ['rust-analyzer'] = {
                            cargo = {
                                features = "all",
                            },
                            check = {
                                command = "clippy",
                            },
                            imports = {
                                granularity = {
                                    group = "module",
                                    enforce = true,
                                },
                            },
                            diagnostics = {
                                enable = true,
                                experimental = {
                                    enable = true,
                                },
                            },
                        }
                    }
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
        end,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",

            "williamboman/mason.nvim",
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
                        border = "rounded", -- style of border for the fidget window
                    },
                },
                config = function(_, opts)
                    require("fidget").setup(opts)
                    vim.cmd [[hi! link FidgetTask FloatBorder]]
                    vim.cmd [[hi! link FidgetTitle Title]]
                end
            },

            {
                "folke/neodev.nvim",
                ft = "lua",
                config = true,
            },

            {
                "ionide/Ionide-vim", -- F# support
                config = function()
                    vim.cmd [[
                        let g:fsharp#fsi_window_command = "botright vnew | lcd #:p:h"
                        let g:fsharp#fsi_extra_parameters = ["--warn:5"]
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
                end
            },
            -- "adelarsq/neofsharp.vim",

            "simrat39/rust-tools.nvim",
        },
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local null_ls = require("null-ls")
            local formatting = null_ls.builtins.formatting
            local diagnostics = null_ls.builtins.diagnostics

            null_ls.setup({
                sources = {
                    formatting.prettierd,
                    diagnostics.eslint_d.with({
                        -- only enable eslint if root has .eslintrc.js
                        condition = function(utils)
                            return utils.root_has_file(".eslintrc") or utils.root_has_file(".eslintrc.js") or
                                utils.root_has_file(".eslintrc.ts")
                        end,
                    }),
                    formatting.black.with({
                        extra_args = { "--fast", "-l", "80" },
                    }),
                    formatting.isort,
                }
            })
        end,
    }
}
