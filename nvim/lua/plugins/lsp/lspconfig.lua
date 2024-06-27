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

        mason.setup()
        mason_lspconfig.setup({
            ensure_installed = { "lua_ls", "jsonls", "marksman", "cssls" },
        })

        local disable_semantic_tokens = {
            lua = true,
        }

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
            [require("typescript-tools")] = function()
                vim.api.nvim_create_autocmd("FileType", {
                    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                    callback = function(event)
                        vim.api.nvim_buf_set_keymap(event.buf, "n", "<leader>oi", ":TSToolsOrganizeImports<cr>", {})
                    end
                })
            end,
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
            angularls = {
                root_dir = lspconfig.util.root_pattern("angular.json", "Gruntfile.js"),
            },
            astro = true,
            texlab = true,
            grammarly = {
                filetypes = { "markdown", "tex", "text" }
            },
            r_language_server = true,
            fsharp_language_server = {
                cmd = { "fsautocomplete", "--project-graph-enabled", "--adaptive-lsp-server-enabled" },
                root_dir = function(filename, _)
                    local root
                    root = lspconfig.util.find_git_ancestor(filename)
                    root = root or lspconfig.util.root_pattern("*.sln")(filename)
                    root = root or lspconfig.util.root_pattern("*.fsproj")(filename)
                    root = root or lspconfig.util.root_pattern("*.fsx")(filename)
                    return root
                end,
            },
        }

        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities()
        )
        capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        }
        capabilities.textDocument.completion.completionItem.insertReplaceSupport = false
        capabilities.textDocument.codeLens = { dynamicRegistration = false }

        for server, config in pairs(servers) do
            if not config then
                return
            end

            if type(config) == "function" then
                config = config()
            end

            if type(config) ~= "table" then
                config = {}
            end

            (type(server) == "string" and lspconfig[server] or server).setup(
                vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                }, config or {})
            )
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(args)
                local bufnr = args.buf
                local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")
                local opts = { buffer = 0 }

                vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

                vim.keymap.set("n", "]d", function()
                    vim.diagnostic.goto_next()
                end, opts)
                vim.keymap.set("n", "[d", function()
                    vim.diagnostic.goto_prev()
                end, opts)

                vim.keymap.set("i", "<C-s>", function()
                    require("cmp").mapping.abort()
                    vim.lsp.buf.signature_help()
                end, opts)

                vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
                    vim.lsp.handlers.signature_help,
                    { focusable = false }
                )

                local filetype = vim.bo[bufnr].filetype
                if disable_semantic_tokens[filetype] then
                    client.server_capabilities.semanticTokensProvider = nil
                end

                -- TODO figure out why it errors
                -- if client.supports_method("textDocument/codeLens") then
                --     vim.lsp.codelens.refresh()
                --     vim.api.nvim_create_autocmd(
                --         { "BufEnter", "InsertLeave", "CursorHold", },
                --         {
                --             buffer = bufnr,
                --             callback = function()
                --                 vim.lsp.codelens.refresh({ bufnr = 0 })
                --             end,
                --             group = vim.api.nvim_create_augroup("refreshCodelens", {}),
                --         }
                --     )
                -- end
            end,
        })
    end,
}
