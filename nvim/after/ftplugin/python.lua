-- sync jupyter notebook
vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>jt",
    "<cmd>!jupytext --sync %<cr>",
    { desc = "Sync jupytext" }
)
