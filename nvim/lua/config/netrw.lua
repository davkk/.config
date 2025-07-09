vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 0
vim.g.netrw_cursor = 0
vim.g.netrw_altfile = 1
vim.g.netrw_sort_sequence = [[[\/]$,*]]

vim.keymap.set("n", "<C-e>", function()
    if vim.bo.filetype == "netrw" then
        vim.cmd.Rexplore()
    else
        vim.cmd.Explore()
    end
end, { noremap = true, silent = true })
