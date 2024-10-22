return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
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
            "jsdoc",
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
        highlight = { enable = true },
        indent = {
            enable = true,
            disable = { "cpp" }
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
        require("treesitter-context").setup({
            enable = true,
            max_lines = 6,
            separator = "─"
        })
    end,
}
