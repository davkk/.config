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
        local lsp = require("config.lsp")
        local util = require("lspconfig.util")

        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
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
                },
                override_capabilities = {
                    semanticTokensProvider = vim.NIL
                },
            },

            biome = true,
            ["typescript-tools"] = {
                callback = function(buffer)
                    vim.keymap.set("n", "<leader>oi", ":TSToolsOrganizeImports<cr>", { buffer = buffer })
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
                init_options = {
                    clangdFileStatus = true,
                    fallbackFlags = { "-stdlib=libc++" },
                },
                callback = function(buffer)
                    vim.keymap.set("n", "<leader><tab>", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = buffer })
                end,
            },

            marksman = true,
            texlab = true,
            grammarly = { filetypes = { "markdown", "tex", "text" } },

            r_language_server = true,

            fsharp_language_server = {
                cmd = { "fsautocomplete", "--project-graph-enabled", "--adaptive-lsp-server-enabled" },
                root_dir = function(filename, _)
                    return util.find_git_ancestor(filename)
                        or util.root_pattern("*.sln", "*.fsproj", "*.fsx")(filename)
                end,
            },
        }

        lsp.setup_servers(servers)

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(event)
                local opts = { buffer = event.buf }

                local client = assert(vim.lsp.get_client_by_id(event.data.client_id), "must have valid client")
                local settings = servers[client.name]
                if type(settings) ~= "table" then
                    settings = {}
                end

                vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("i", "<C-s>", function()
                    require("cmp").abort()
                    vim.lsp.buf.signature_help()
                end, opts)

                -- set client-specific keymaps
                if settings.callback then
                    settings.callback(event.buf)
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
