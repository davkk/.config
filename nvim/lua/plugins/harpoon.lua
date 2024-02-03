return {
    "ThePrimeagen/harpoon",
    lazy = false,
    branch = "harpoon2",
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
            harpoon:list():append()
        end)
        vim.keymap.set("n", "<leader>h", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
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
