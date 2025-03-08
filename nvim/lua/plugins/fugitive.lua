return {
    "tpope/vim-fugitive",
    lazy = false,
    config = function()
        local opts = { noremap = true, silent = true }

        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, opts)
        vim.keymap.set("n", "<leader>gp", function() vim.cmd.Git "push" end, opts)
        vim.keymap.set("n", "<leader>gf", function() vim.cmd.Git "push -f" end, opts)

        vim.keymap.set("n", "<leader>gd", function()
            vim.cmd.Gvdiffsplit()
            vim.cmd.wincmd "p"
        end, opts)
        vim.keymap.set("n", "<leader>gD", function()
            vim.cmd.Gvdiffsplit(vim.fn.input("diff> "))
            vim.cmd.wincmd "p"
        end, opts)

        vim.keymap.set("n", "<leader>gb", function() vim.cmd.Git("blame") end, opts)

        vim.keymap.set("n", "gh", function() vim.cmd.diffget "//2" end, opts)
        vim.keymap.set("n", "gl", function() vim.cmd.diffget "//3" end, opts)
    end
}
