return {
    "mbbill/undotree",
    keys = { "<leader>u" },
    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        vim.g.undotree_DiffAutoOpen = 0
    end
}
