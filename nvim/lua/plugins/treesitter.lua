return {
    { 
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        opts = {
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
            ensure_installed = {
                "help",
                "html",
                "elm",
                "javascript",
                "typescript",
                "astro",
                "json",
                "graphql",
                "c", 
                "cpp",
                "lua",
                "rust",
                "markdown",
                "python",
                "yaml",
            },
            sync_install = true,
            auto_install = true,
            indent = { enable = true },
            autopairs = { enable = true },
            autotag = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
