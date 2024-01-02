return {
    "pappasam/nvim-repl",
    init = function()
        vim.g["repl_filetype_commands"] = {
            python = "ipython --no-autoindent",
        }
    end,
    keys = {
        {
            "<leader>rt",
            "<cmd>ReplToggle<cr>",
            desc = "Toggle nvim-repl"
        },
        {
            "<leader><cr>",
            "<cmd>ReplRunCell<cr>",
            desc = "nvim-repl run cell"
        },
        {
            "<leader><cr>",
            "<Plug>ReplSendVisual<cr>",
            desc = "nvim-repl send visual",
            mode = "v",
        },
    },
}
