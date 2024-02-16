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
        default_file_explorer = true,
        restore_win_options = true,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        keymaps = {
            ["g?"] = "actions.show_help",
            ["<C-y>"] = "actions.select",
            ["<CR>"] = "actions.select",
            ["<leader>v"] = "actions.select_vsplit",
            ["<leader>x"] = "actions.select_split",
            ["<leader>t"] = "actions.select_tab",
            ["<leader>R"] = "actions.refresh",
            ["<C-c>"] = "actions.close",
            ["q"] = "actions.close",
            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["`"] = "actions.cd",
            ["~"] = "actions.tcd",
            ["g."] = "actions.toggle_hidden",
        },
        use_default_keymaps = false,
        view_options = { show_hidden = true, },
        float = {
            border = "solid",
        }
    },
    config = function(_, opts)
        local oil = require("oil")
        oil.setup(opts)

        vim.keymap.set("n", "<C-e>", oil.toggle_float, { noremap = true, silent = true })
    end,
}
