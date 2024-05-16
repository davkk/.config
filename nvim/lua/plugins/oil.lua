return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        columns = { { "icon", add_padding = false } },
        win_options = {
            wrap = false,
            colorcolumn = "",
            number = true,
            relativenumber = true,
            cursorline = false,
            foldcolumn = "0",
            spell = false,
            list = false,
            conceallevel = 3,
            concealcursor = "n",
        },
        view_options = { show_hidden = true, },
        float = {
            border = "solid",
            max_width = math.ceil(vim.o.columns * 0.8),
            padding = 3,
        }
    },
    config = function(_, opts)
        local oil = require("oil")
        oil.setup(opts)
        vim.keymap.set("n", "<C-e>", oil.open, { noremap = true, silent = true })
    end,
}
