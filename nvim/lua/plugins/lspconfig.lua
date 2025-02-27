return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspStart", "LspStop" },
    config = function()
        local lspconfig = require("lspconfig")
        local util = require("lspconfig.util")
        local completion = require("config.completion")

        local servers = {
            lua_ls = {
                cmd = { vim.env.HOME .. "/.local/share/lua-language-server/bin/lua-language-server" },
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

            biome = true,
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

            jdtls = {
                cmd = { vim.env.HOME .. "/.local/share/jdtls/bin/jdtls" },
            },

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
