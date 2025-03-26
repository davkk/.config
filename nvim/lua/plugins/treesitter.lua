require("nvim-treesitter.configs").setup {
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
}

vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
