local oil = require "oil"

oil.setup {
    win_options = {
        wrap = false,
        colorcolumn = "",
        number = true,
        relativenumber = true,
        cursorline = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "n",
    },
    delete_to_trash = true,
    view_options = { show_hidden = true },
    cleanup_delay_ms = 200,
}

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.keymap.set("n", "<C-e>", oil.open, { noremap = true, silent = true })
