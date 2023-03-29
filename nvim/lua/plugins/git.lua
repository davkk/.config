return {
    {
        "tpope/vim-fugitive",
        cmd = { "G", "Git" },
        keys = { "<leader>g", },
        config = function()
            local keymap = vim.keymap
            local opts = { noremap = true, silent = true }

            keymap.set('n', '<leader>gg', '<cmd>:vertical G<CR>', opts)
            keymap.set('n', '<leader>gw', '<cmd>:Gwrite<CR>', opts)
            keymap.set('n', '<leader>gp', '<cmd>:G push<CR>', opts)
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = true,
    },
}
