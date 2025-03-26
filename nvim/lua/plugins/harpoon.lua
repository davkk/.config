local harpoon = require("harpoon")
local harpoon_ext = require("harpoon.extensions")

harpoon:setup {
    settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
    },
}
harpoon:extend(harpoon_ext.builtins.highlight_current_file())

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
