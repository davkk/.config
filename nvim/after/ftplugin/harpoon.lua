local config = vim.api.nvim_win_get_config(0)
vim.api.nvim_win_set_config(0, {
    relative = config.relative,
    width = vim.o.columns,
    height = math.floor(vim.o.lines * 0.4),
    row = vim.o.lines,
    col = 1,
    border = "solid"
})
