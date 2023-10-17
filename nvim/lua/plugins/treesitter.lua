return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        dependencies = {
            "nvim-treesitter/playground",
            "JoosepAlviste/nvim-ts-context-commentstring",
            "nvim-treesitter/nvim-treesitter-context",
            { "elgiano/nvim-treesitter-angular", branch = "topic/jsx-fix" },
            "nkrkv/nvim-treesitter-rescript",
        },
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "vimdoc",
                "bash",
                "awk",
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
            context_commentstring = { enable = true, enable_autocmd = false }
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)

            require("treesitter-context").setup({
                enable = true,
                max_lines = 0,
            })
        end,
    },
}
