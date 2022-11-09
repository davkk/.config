local status, ts = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

ts.setup {
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = true,
        disable = {},
    },
    ensure_installed = {
        "python",
        "json",
        "css",
        "html",
        "lua",
        "markdown",
    },
    autotag = {
        enable = true,
    },
}
