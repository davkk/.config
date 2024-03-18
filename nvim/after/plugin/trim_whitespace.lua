vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("TrimWhitespaceGroup", { clear = true }),
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
