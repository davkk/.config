return {
    {
        "tpope/vim-fugitive",
        cmd = { "G", "Git" },
        keys = { "<leader>g", "gl", "gh" },
        config = function()
            local opts = { noremap = true, silent = true }

            vim.keymap.set("n", "<leader>gs", vim.cmd.Git, opts)
            vim.keymap.set("n", "<leader>gp", "<cmd>:G push<CR>", opts)
            vim.keymap.set("n", "<leader>gP", "<cmd>:G pull --rebase<CR>", opts)

            -- do git merges easily:
            vim.keymap.set("n", "gh", "<cmd>diffget //2<CR>", opts) -- gh = choose left
            vim.keymap.set("n", "gl", "<cmd>diffget //3<CR>", opts) -- gl = choose right
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPost",
        opts = {
            signs = {
                add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr" },
                change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr" },
                delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr" },
                topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr" },
                changedelete = { hl = "GitSignsDelete", text = "~", numhl = "GitSignsChangeNr" },
            },

            numhl = true,
            linehl = false,
            word_diff = false,

            current_line_blame_opts = {
                delay = 2000,
                virt_text_pos = "eol",
            },

            preview_config = { border = "solid", }
        },
        config = function(_, opts)
            local gs = require("gitsigns")
            gs.setup(opts)

            vim.keymap.set("n", "<leader>gb", gs.blame_line);
            vim.keymap.set("n", "<leader>gd", gs.diffthis);
        end
    },
    {
        "ThePrimeagen/git-worktree.nvim",
        dependencies = { "stevearc/oil.nvim" },
        opts = { update_on_change_command = "Oil ." },
    }
}
