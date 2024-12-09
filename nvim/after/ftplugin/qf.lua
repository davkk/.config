vim.keymap.set(
    "n",
    "<leader>f",
    require("fzf-lua").quickfix,
    { buffer = 0 }
)
