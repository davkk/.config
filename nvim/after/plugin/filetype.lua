vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd.set "filetype=term"
    end,
})

vim.filetype.add {
    extension = {
        ["hip"] = "cuda",
    },
    filename = {
        [".eslint-ts-config"] = "jsonc",
    },
    pattern = {
        [".*.component.html"] = "angular",
    },
}
