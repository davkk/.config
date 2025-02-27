vim.api.nvim_create_user_command(
    "TrimWhitespace",
    function()
        vim.cmd [[%s/\s\+$//e]]
    end,
    {}
)
