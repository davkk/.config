vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
    callback = function ()
        local api = require("typescript-tools.api")
        local c = require("typescript-tools.protocol.constants")
        api.organize_imports(true)
    end,
    group = vim.api.nvim_create_augroup("TSFormatting", { clear = true }),
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { ".eslint-ts-config" },
    command = "setlocal filetype=jsonc",
    group = vim.api.nvim_create_augroup("SetJSONC", { clear = true }),
})
