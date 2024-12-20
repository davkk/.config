local function client_capabilities()
    return vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities()
    )
end

local function try_require(module)
    local ok, result = pcall(require, module)
    return ok and result or nil
end

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "Mason" },
    dependencies = {
        "Saghen/blink.cmp",
        "williamboman/mason.nvim",
        { "pmizio/typescript-tools.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    config = function()
        require("mason").setup()

        local util = require("lspconfig.util")
        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                            disable = { "missing-fields" },
                        },
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
                    fallbackFlags = { "-stdlib=libc++" },
                },
                callback = function(buffer)
                    vim.keymap.set("n", "<leader><tab>", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = buffer })
                end,
            },

            marksman = true,
            texlab = true,

            r_language_server = true,

            fsharp_language_server = {
                cmd = { "fsautocomplete", "--project-graph-enabled", "--adaptive-lsp-server-enabled" },
                root_dir = function(filename, _)
                    return vim.fs.dirname(vim.fs.find(".git", { path = filename, upward = true })[1])
                        or util.root_pattern("*.sln", "*.fsproj", "*.fsx")(filename)
                end,
            },

            jdtls = true,
        }

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

            local server = try_require('lspconfig.configs.' .. name)
                and require('lspconfig')[name]
                or try_require(name)

            if server then
                server.setup(
                    vim.tbl_deep_extend("force", {
                        capabilities = client_capabilities(),
                    }, config)
                )
            else
                vim.notify(
                    string.format("Cannot find server: '%s'", name),
                    vim.log.levels.WARN
                )
            end
        end

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
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

                -- set server-specific attach
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
