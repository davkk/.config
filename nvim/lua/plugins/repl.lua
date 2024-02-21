return {
    "pappasam/nvim-repl",
    ft = { "python", "r", },
    init = function()
        vim.g["repl_filetype_commands"] = {
            python = "ipython --no-autoindent",
            r = "R",
        }
    end,
    config = function()
        vim.keymap.set(
            "n",
            "<leader>rt",
            "<cmd>ReplToggle<cr>",
            { desc = "Toggle nvim-repl" }
        )
        vim.keymap.set(
            "n",
            "<leader><cr>",
            "<Plug>ReplSendCell<cr>",
            { desc = "nvim-repl run cell" }
        )
        vim.keymap.set(
            "v",
            "<leader><cr>",
            "<Plug>ReplSendVisual<cr>",
            { desc = "nvim-repl run cell" }
        )
    end,
}
