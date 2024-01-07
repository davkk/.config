return {
    "pappasam/nvim-repl",
    keys = { "<leader>rt", "<leader><cr>" },
    init = function()
        vim.g["repl_filetype_commands"] = {
            python = "ipython --no-autoindent",
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
            { "n", "v" },
            "<leader><cr>",
            "<cmd>ReplRunCell<cr>",
            { desc = "nvim-repl run cell" }
        )
    end,
}
