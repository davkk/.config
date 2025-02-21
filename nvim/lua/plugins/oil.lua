return {
    "stevearc/oil.nvim",
    lazy = false,
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
        keymaps = {
            ["g?"] = { "actions.show_help", mode = "n" },
            ["<C-y>"] = "actions.select",
            ["<C-s>"] = { "actions.select", opts = { vertical = true } },
            ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
            ["<C-t>"] = { "actions.select", opts = { tab = true } },
            ["<C-c>"] = { "actions.close", mode = "n" },
            ["<C-l>"] = "actions.refresh",
            ["-"] = { "actions.parent", mode = "n" },
            ["_"] = { "actions.open_cwd", mode = "n" },
            ["`"] = { "actions.cd", mode = "n" },
            ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
            ["gx"] = "actions.open_external",
            ["g."] = { "actions.toggle_hidden", mode = "n" },
            ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
        use_default_keymaps = false,
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
    end,
}
