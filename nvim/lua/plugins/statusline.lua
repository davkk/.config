return {
    "brianaung/yasl.nvim",
    priority = 1001, -- load after theme to apply highlight groups correctly
    lazy = false,
    opts = {
        global = true,
        enable_icons = true,
        components = {
            "%<%f %h%m%r%w", -- filename
            " ",
            "gitdiff",
            " ",
            "%=",
            " ",
            "diagnostics",
            " ",
            "%8.(%l, %c%V%)", -- location, and progress
        }
    }
}
