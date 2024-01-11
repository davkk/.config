---@alias Color { fg: string, bg: string, sp: string, bold: boolean, italic: boolean, undercurl: boolean, underline: boolean, underdouble: boolean, underdotted: boolean, underdashed: boolean, strikethrough: boolean }

local M = {}

---@class Options
M.options = {
    bold_vert_split = true,

    dim_nc_background = false,

    disable_background = true,
    disable_float_background = false,
    disable_italics = true,

    groups = {
        background = "base",
        background_nc = "nc",
        panel = "surface",
        panel_nc = "base",
        border = "highlight_med",
        comment = "muted",
        link = "iris",
        punctuation = "muted",
        error = "error",
        hint = "hint",
        info = "info",
        warn = "warning",
        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        headings = {
            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
        },
    },
    highlight_groups = {},
}

---@param options Options|nil
function M.extend(options)
    M.options = vim.tbl_deep_extend("force", M.options, options or {})
end

return M
