local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>gs", vim.cmd.Git, opts)
vim.keymap.set("n", "<leader>gp", function() vim.cmd.Git "push" end, opts)
vim.keymap.set("n", "<leader>gf", function() vim.cmd.Git "push -f" end, opts)

vim.keymap.set("n", "<leader>gd", function()
    vim.cmd [[ Gvdiffsplit! ]]
end, opts)
vim.keymap.set("n", "<leader>gD", function()
    vim.cmd("Gvdiffsplit!" .. vim.fn.input("diff> "))
end, opts)

vim.keymap.set("n", "<leader>gb", function()
    vim.cmd.Git("blame")
    vim.cmd.norm "A"
end, opts)
