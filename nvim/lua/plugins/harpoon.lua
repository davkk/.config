return {
    "ThePrimeagen/harpoon",
    keys = {
        "<leader>a",
        "<leader>h",
        "<leader>1",
        "<leader>2",
        "<leader>3",
        "<leader>4",
        "<leader>5",
    },
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        settings = {
            save_on_toggle = true,
            sync_on_ui_close = true,
        },
    },
    config = function(_, opts)
        local harpoon = require("harpoon")
        harpoon:setup(opts)

        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
        end)
        vim.keymap.set("n", "<leader>h", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)

        vim.keymap.set("n", "<C-c>", function()
            harpoon.ui:close_menu()
        end)

        for i = 1, 5 do
            vim.keymap.set(
                "n",
                string.format("<leader>%s", i),
                function()
                    harpoon:list():select(i)
                end
            )
        end
    end,
}
