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
            harpoon:list():add()
        end)
        vim.keymap.set("n", "<leader>h", function()
            harpoon.ui:toggle_quick_menu(harpoon:list(), {
                border = "solid",
                ui_width_ratio = 0.85,
            })
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
