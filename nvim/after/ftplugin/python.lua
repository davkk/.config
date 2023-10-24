-- sync jupyter notebook
vim.keymap.set(
    "n",
    "<leader>ns",
    "<cmd>!jupytext --sync %<cr>",
    { desc = "Sync jupytext" }
)
