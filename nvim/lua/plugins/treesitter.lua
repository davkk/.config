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
            "luadoc",
            "vim",
            "vimdoc",
            "gitcommit",
            "gitignore",
            "git_config",
            "git_rebase",
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
            "doxygen",
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
                local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
                return stats and stats.size > max_filesize
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
            max_lines = 6,
        })
    end,
}
