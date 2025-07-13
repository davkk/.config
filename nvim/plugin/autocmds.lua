vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("user.yank", { clear = true }),
    desc = "Hightlight selection on yank",
    pattern = "*",
    callback = function()
        vim.hl.on_yank { timeout = 150 }
    end,
})

vim.api.nvim_create_user_command("TrimWhitespace", function()
    vim.cmd [[%s/\s\+$//e]]
end, {})
