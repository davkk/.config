local palette = require("rose-pine-tinted.palette")

local modes = {
    ["n"] = palette.rose,          -- NORMAL
    ["no"] = palette.rose,         -- NORMAL
    ["v"] = palette.iris,          -- VISUAL
    ["V"] = palette.iris,          -- VISUALINE
    [""] = palette.iris,          -- VISUALLOCK
    ["s"] = palette.gold,          -- SELECT
    ["S"] = palette.gold,          -- SELECTINE
    [""] = palette.gold,          -- SELECTLOCK
    ["i"] = palette.foam,          -- INSERT
    ["ic"] = palette.foam,         -- INSERT
    ["R"] = palette.pine,          -- REPLACE
    ["Rv"] = palette.pine,         -- VISUALEPLACE
    ["c"] = palette.love,          -- COMMAND
    ["cv"] = palette.love,         -- VIMX
    ["ce"] = palette.love,         -- EX
    ["r"] = palette.love,          -- PROMPT
    ["rm"] = palette.love,         -- MOAR
    ["r?"] = palette.pine,         -- CONFIRM
    ["!"] = palette.love,          -- SHELL
    ["t"] = palette.highlight_med, -- TERMINAL
}

---@param mode string
local function highlight(mode)
    local fg = modes[mode] or palette.text

    vim.api.nvim_set_hl(0, "ModeMsg", { fg = fg, bg = palette.none, bold = true })
end

local mode_highlight_group = vim.api.nvim_create_augroup("ModeHighlight", {})

vim.api.nvim_create_autocmd("ModeChanged", {
    group = mode_highlight_group,
    pattern = "*:[^it]",
    callback = function(scene)
        local mode = vim.split(scene.match, ":")[2]
        highlight(mode)
    end
})

vim.api.nvim_create_autocmd("InsertEnter", {
    group = mode_highlight_group,
    callback = function()
        highlight("i")
    end,
})

vim.api.nvim_create_autocmd({ "TermEnter", "TermOpen" }, {
    group = mode_highlight_group,
    callback = function()
        highlight("t")
    end,
})
