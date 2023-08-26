local M = {}

local lsp_servers = {
    "lua_ls",
    "pyright",
    "marksman",
    "astro",
    "pyright",
    "tsserver",
    "angularls",
}

local signs = {
    Error = "󰅂 ",
    Warn = "󰅂 ",
    Hint = "󰅂 ",
    Info = "󰅂 ",
}

M.setup_lsp_keybinds = function(bufnr)
    local opts = { buffer = bufnr, noremap = false, silent = true }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "<leader>gT", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>gI", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts) -- open detailed error message window

    vim.keymap.set("n", "<leader>dn", function()
        vim.diagnostic.goto_next {
            severity = M.get_highest_error_severity(),
            wrap = true,
            float = true,
        }
    end, opts)
    vim.keymap.set("n", "<leader>dp", function()
        vim.diagnostic.goto_prev {
            severity = M.get_highest_error_severity(),
            wrap = true,
            float = true,
        }
    end, opts)

    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
    vim.keymap.set("v", "<leader>f", vim.lsp.buf.format, opts)

    vim.keymap.set("i", "<C-h>",
        function()
            require("cmp").mapping.abort()
            vim.lsp.buf.signature_help()
        end,
        opts)
end

M.server_setup = function(server, custom_config)
    server.setup(vim.tbl_deep_extend("force", {
        on_attach = M.on_attach,
        capabilities = M.capabilities,
        flags = {
            debounce_text_changes = 100,
        },
    }, custom_config or {}))
end

M.plugins = {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",

            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim"
        },
        config = function()
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")

            M.setup_diagnostics()

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
                ensure_installed = lsp_servers,
                handlers = {
                    function(server_name)
                        M.server_setup(lspconfig[server_name])
                    end,
                }
            })

            M.server_setup(lspconfig.lua_ls, {
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

            M.server_setup(lspconfig.pyright, {
                root_dir = lspconfig.util.root_pattern("pyproject.toml"),
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "off"
                        }
                    }
                }
            })

            M.server_setup(lspconfig.cssls, {
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

            M.server_setup(lspconfig.ocamllsp)

            M.server_setup(lspconfig.rescriptls, {
                init_options = {
                    extensionConfiguration = {
                        allowBuiltInFormatter = true,
                        askToStartBuild = false,
                        autoRunCodeAnalysis = true,
                        codeLens = true,
                        inlayHints = { enable = true },
                    },
                },
            })

            M.server_setup(require("ionide"), {
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
                border = "rounded", -- style of border for the fidget window
            },
        },
        config = true
    },

}

M.setup_diagnostics = function()
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    vim.diagnostic.config({
        severity_sort = true,
        virtual_text = {
            prefix = "󱓻",
            source = "if_many",
        },
        virtual_lines = false,
        signs = { active = signs },
        underline = true,
        update_in_insert = false,
        float = {
            show_header = true,
            style = 'minimal',
            border = 'rounded',
            source = 'if_many',
            header = '',
            prefix = '',
        },
    })
end

local c = vim.lsp.protocol.make_client_capabilities()
c.textDocument.completion.completionItem.snippetSupport = true
c.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}

M.capabilities = require("cmp_nvim_lsp").default_capabilities(c)

M.create_codelens_autocmd = function(client, bufnr)
    if client.supports_method("textDocument/codeLens") then
        vim.lsp.codelens.refresh()

        local refreshCodelens = vim.api.nvim_create_augroup("refreshCodelens", {})

        vim.api.nvim_create_autocmd({
            "BufEnter",
            "InsertLeave",
            "TextChanged",
        }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
            group = refreshCodelens,
        })
    end
end

M.get_highest_error_severity = function()
    -- Go to the next diagnostic, but prefer going to errors first
    -- In general, I pretty much never want to go to the next hint
    local severity_levels = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.WARN,
        vim.diagnostic.severity.INFO,
        vim.diagnostic.severity.HINT,
    }
    for _, level in ipairs(severity_levels) do
        local diags = vim.diagnostic.get(0, { severity = { min = level } })
        if #diags > 0 then
            return level, diags
        end
    end
end

M.setup_lsp_handlers = function()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = "rounded" }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
            focusable = false,
            border = "rounded",
        }
    )
end

M.on_attach = function(client, bufnr)
    M.setup_lsp_keybinds(bufnr)
    M.create_codelens_autocmd(client, bufnr)
    M.setup_lsp_handlers()
end

return M.plugins
