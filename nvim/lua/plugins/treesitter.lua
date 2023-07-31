return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/playground",
            "JoosepAlviste/nvim-ts-context-commentstring",
            "nvim-treesitter/nvim-treesitter-context",
            { "elgiano/nvim-treesitter-angular", branch = "topic/jsx-fix" },
        },
        build = ":TSUpdate",
        lazy = false,
        opts = {
            ensure_installed = {
                "vimdoc",
                "html",
                "javascript",
                "typescript",
                "tsx",
                "css",
                "astro",
                "json",
                "graphql",
                "c",
                "cpp",
                "lua",
                "vim",
                "rust",
                "markdown",
                "python",
                "yaml",
                "angular"
            },
            sync_install = true,
            auto_install = false,
            playground = { enable = true },
            highlight = {
                enable = true,
                disable = function(_, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            context_commentstring = { enable = true }
        },
        config = function(_, opts)
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

            parser_config.fsharp = {
                install_info = {
                    url = "https://github.com/Nsidorenco/tree-sitter-fsharp",
                    branch = "develop",
                    files = { "src/scanner.cc", "src/parser.c" },
                    generate_requires_npm = true,
                    requires_generate_from_grammar = true
                },
                filetype = "fsharp",
            }

            parser_config.xml = {
                install_info = {
                    url = "https://github.com/dorgnarg/tree-sitter-xml",
                    branch = "main",
                    files = { "src/parser.c" },
                    requires_generate_from_grammar = true,
                },
                filetype = "xml",
            }

            require("nvim-treesitter.configs").setup(opts)

            require("treesitter-context").setup({
                enable = true,
                max_lines = 0,
            })
        end,
    },
}
