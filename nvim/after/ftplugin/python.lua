-- sync jupyter notebook
vim.keymap.set(
    "n",
    "<leader>jt",
    "<cmd>!jupytext --sync %<cr>",
    { desc = "Sync jupytext" }
)
