return {
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        config = function()
            local opts = { noremap = true, silent = true }

            vim.keymap.set("n", "<leader>gs", vim.cmd.Git, opts)
            vim.keymap.set("n", "<leader>gp", "<cmd>:G push<CR>", opts)
            vim.keymap.set("n", "<leader>gf", "<cmd>:G push -f<CR>", opts)
            vim.keymap.set("n", "<leader>gP", "<cmd>:G pull origin --rebase<CR>", opts)

            -- do git merges easily:
            vim.keymap.set("n", "gh", "<cmd>diffget //2<CR>", opts) -- gh = choose left
            vim.keymap.set("n", "gl", "<cmd>diffget //3<CR>", opts) -- gl = choose right
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
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
            vim.keymap.set("n", "<leader>gD", ":Gitsigns diffthis ");
        end
    },
}
