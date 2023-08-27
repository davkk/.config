local config = require('rose-pine.config')
local M = {}

function M.colorscheme()
    vim.opt.termguicolors = true
    if vim.g.colors_name then
        vim.cmd('hi clear')
        vim.cmd('syntax reset')
    end
    vim.g.colors_name = 'rose-pine'

    require('rose-pine.theme')._load(config.options)
end

function M.setup(options)
    config.extend(options)
end

return M
