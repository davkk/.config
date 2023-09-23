local p = require('rose-pine.palette')

return {
    normal = {
        a = { bg = p.rose, fg = p.base, gui = 'bold' },
        b = { bg = "none", fg = p.rose },
        c = { bg = "none", fg = p.text },
    },
    insert = {
        a = { bg = p.foam, fg = p.base, gui = 'bold' },
        b = { bg = "none", fg = p.foam },
        c = { bg = "none", fg = p.text },
    },
    visual = {
        a = { bg = p.iris, fg = p.base, gui = 'bold' },
        b = { bg = "none", fg = p.iris },
        c = { bg = "none", fg = p.text },
    },
    replace = {
        a = { bg = p.pine, fg = p.base, gui = 'bold' },
        b = { bg = "none", fg = p.pine },
        c = { bg = "none", fg = p.text },
    },
    command = {
        a = { bg = p.love, fg = p.base, gui = 'bold' },
        b = { bg = "none", fg = p.love },
        c = { bg = "none", fg = p.text },
    },
    inactive = {
        a = { bg = p.muted, fg = p.base, gui = 'bold' },
        b = { bg = "none", fg = p.muted },
        c = { bg = "none", fg = p.muted },
    },
}
