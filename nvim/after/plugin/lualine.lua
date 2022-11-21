local status, lualine = pcall(require, 'lualine')
if not status then
    return
end

local hide_in_width = function() return vim.fn.winwidth(0) > 80 end

local diagnostics = {
    "diagnostics",
    sources = {"nvim_diagnostic"},
    sections = {"error", "warn"},
    symbols = { error = " ", warn = " ", hint = " ", info = " " },
    colored = false,
    update_in_insert = false,
    always_visible = true
}

local diff = {
    "diff",
    colored = false,
    symbols = {added = " ", modified = " ", removed = " "}, -- changes diff symbols
    cond = hide_in_width
}

local filetype = {
    function()
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        if buf_ft == "toggleterm" then return "" end
        return buf_ft
    end,
}

local branch = {"branch", icons_enabled = true, icon = ""}

lualine.setup({
    options = {
        icons_enabled = true,
        theme = 'gruvbox',
        component_separators = '│',
        section_separators = '',
        disabled_filetypes = {
            statusline = {"dashboard", "NvimTree", "Outline"},
        },
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {branch, diff},
        lualine_x = {"%="},
        lualine_y = {diagnostics},
        lualine_z = {filetype},
    },
    inactive_sections = {
        lualine_c = {"%=", filename},
    },
})
