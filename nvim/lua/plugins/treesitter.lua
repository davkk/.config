return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        ensure_installed = {
            "lua",
            "luadoc",
            "vim",
            "vimdoc",
            "bash",
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
            "angular"
        },
        sync_install = true,
        auto_install = false,
        highlight = { enable = true },
        indent = {
            enable = true,
            disable = { "cpp" }
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
