return {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    opts = {
        menu = {
            width = math.floor(vim.o.columns * 4 / 5),
            height = math.floor(vim.o.lines * 3 / 5),
        },
        excluded_filetypes = { "harpoon", "oil", "term" },
    },
    config = function(_, opts)
        require("harpoon").setup(opts)
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "add file to Harpoon" })
        vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "toggle Harpoon quick menu" })

        for i = 1, 5 do
            vim.keymap.set(
                "n",
                string.format("<leader>%s", i),
                function()
                    require("harpoon.ui").nav_file(i)
                end,
                { desc = string.format("Harpoon navigate to file %s", i) }
            )
        end
    end,
}
