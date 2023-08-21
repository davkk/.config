return {
    {
        "tpope/vim-fugitive",
        cmd = { "G", "Git" },
        keys = { "<leader>g", },
        config = function()
            local keymap = vim.keymap
            local opts = { noremap = true, silent = true }

            keymap.set("n", "<leader>gs", "<cmd>:vertical G<CR>", opts)
            keymap.set("n", "<leader>gp", "<cmd>:G push<CR>", opts)
            keymap.set("n", "<leader>gP", "<cmd>:G pull --rebase=preserve<CR>", opts)

            -- do git merges easily
            -- gh = choose left
            -- gl = choose right
            keymap.set("n", "gh", "<cmd>diffget //2<CR>", opts)
            keymap.set("n", "gl", "<cmd>diffget //3<CR>", opts)
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            signs = {
                add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr" },
                change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr" },
                delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr" },
                topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr" },
                changedelete = { hl = "GitSignsDelete", text = "~", numhl = "GitSignsChangeNr" },
            },

            numhl = true,

            -- Highlights the _whole_ line.
            --    Instead, use gitsigns.toggle_linehl()
            linehl = false,

            -- Highlights just the part of the line that has changed
            --    Instead, use gitsigns.toggle_word_diff()
            word_diff = false,

            current_line_blame_opts = {
                delay = 2000,
                virt_text_pos = "eol",
            },
        },
        config = function (_, opts)
            local gs = require("gitsigns").setup(opts)

            vim.keymap.set("n", "<leader>gb", gs.blame_line);
        end
    },
}
