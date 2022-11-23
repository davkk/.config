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
        "latex",
    },
    autotag = {
        enable = true,
    },
}

local ok, ts_context = pcall(require, "treesitter-context")
if not ok then return end

ts_context.setup {
    enable = true
}
