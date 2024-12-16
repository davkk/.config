return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        columns = { { "icon", add_padding = false } },
        win_options = {
            winbar = "%{v:lua.CustomOilBar()}",
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
        delete_to_trash = true,
        view_options = { show_hidden = true, },
        cleanup_delay_ms = 200,
        watch_for_changes = true,
        float = {
            border = "solid",
            max_width = math.ceil(vim.o.columns * 0.6),
            padding = 3,
        },
    },
    config = function(_, opts)
        local oil = require("oil")
        oil.setup(opts)

        vim.keymap.set("n", "<C-e>", oil.open, { noremap = true, silent = true })

        CustomOilBar = function()
            local path = vim.fn.expand "%"
            path = path:gsub("oil://", "")
            path = vim.fn.fnamemodify(path, ":.")
            return (path:sub(1, 1) == "/" and "" or "./") .. path
        end
    end,
}
