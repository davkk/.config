return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "refractalize/oil-git-status.nvim"
    },
    opts = {
        columns = { { "icon", add_padding = false, }, },
        win_options = {
            wrap = false,
            signcolumn = "yes:2",
            cursorcolumn = false,
            number = true,
            relativenumber = true,
            cursorline = true,
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
            ["<C-v>"] = "actions.select_vsplit",
            ["<C-x>"] = "actions.select_split",
            ["<C-t>"] = "actions.select_tab",
            ["<C-r>"] = "actions.refresh",
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
            max_width = 80,
            max_height = 30,
            win_options = { winblend = 10, },
        },
    },
    config = function(_, opts)
        local oil = require("oil")
        local oil_git_status = require("oil-git-status")

        oil.setup(opts)
        oil_git_status.setup()

        vim.keymap.set("n", "<C-e>", oil.open, { noremap = true, silent = true })
    end,
}
