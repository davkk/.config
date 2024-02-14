return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
        "nvim-treesitter/nvim-treesitter-context",
    },
    opts = {
        ensure_installed = {
            "lua",
            "vim",
            "gitcommit",
            "gitignore",
            "git_config",
            "git_rebase",
            "vimdoc",
            "bash",
            "awk",
            "html",
            "markdown",
            "javascript",
            "typescript",
            "tsx",
            "css",
            "json",
            "c",
            "cpp",
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
                local max_filesize = 100 * 1024     -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat,
                    vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)

        vim.g.skip_ts_context_commentstring_module = true

        require("treesitter-context").setup({
            enable = true,
            max_lines = 4,
        })
    end,
}
