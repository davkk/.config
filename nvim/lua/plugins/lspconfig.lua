return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        local completion = require("config.completion")

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                            disable = { "missing-fields" },
                        },
                        workspace = {
                            library = {
                                vim.env.VIMRUNTIME,
                                "${3rd}/luv/library",
                            },
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false, },
                    },
                },
                override_capabilities = {
                    semanticTokensProvider = vim.NIL
                },
            },

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
            angularls = { root_dir = vim.fs.root(0, { "angular.json", "Gruntfile.js" }) },

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
                root_dir = vim.fs.root(0, { "pyproject.toml" }),
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
                    vim.keymap.set("n", "<leader><tab>", vim.cmd.ClangdSwitchSourceHeader, { buffer = buffer })
                end,
            },

            marksman = true,
            texlab = true,

            zls = true,
        }

        local capabilities = completion.get_capabilities()

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

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf })
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = event.buf })
                vim.keymap.set("n", "K", function()
                    vim.lsp.buf.hover { border = "solid" }
                end, { buffer = event.buf })
                vim.keymap.set({ "i", "x" }, "<C-s>", function()
                    vim.lsp.buf.signature_help { border = "solid" }
                end, { buffer = event.buf })

                completion.setup(client, event.buf)

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
    end,
}
