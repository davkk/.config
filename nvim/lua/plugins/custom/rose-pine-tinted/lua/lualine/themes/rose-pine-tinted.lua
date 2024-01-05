local p = require("rose-pine-tinted.palette")

return {
    normal = {
        a = { bg = p.rose, fg = p.base, gui = "bold" },
        b = { bg = p.none, fg = p.rose },
        c = { bg = p.none, fg = p.text },
    },
    insert = {
        a = { bg = p.foam, fg = p.base, gui = "bold" },
        b = { bg = p.none, fg = p.foam },
        c = { bg = p.none, fg = p.text },
    },
    visual = {
        a = { bg = p.iris, fg = p.base, gui = "bold" },
        b = { bg = p.none, fg = p.iris },
        c = { bg = p.none, fg = p.text },
    },
    replace = {
        a = { bg = p.pine, fg = p.base, gui = "bold" },
        b = { bg = p.none, fg = p.pine },
        c = { bg = p.none, fg = p.text },
    },
    command = {
        a = { bg = p.love, fg = p.base, gui = "bold" },
        b = { bg = p.none, fg = p.love },
        c = { bg = p.none, fg = p.text },
    },
    terminal = {
        a = { bg = p.gold, fg = p.base, gui = "bold" },
        b = { bg = p.none, fg = p.gold },
        c = { bg = p.none, fg = p.text },
    },
    inactive = {
        a = { bg = p.highlight_high, fg = p.base, gui = "bold" },
        b = { bg = p.none, fg = p.highlight_high },
        c = { bg = p.none, fg = p.highlight_high },
    },
}
