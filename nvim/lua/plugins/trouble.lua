return {
    "folke/trouble.nvim",
    keys = { "<leader>tt", "]t", "[t" },
    opts = {
        open_no_results = true,
        icons = {
            indent = {
                fold_closed = " ",
            }
        },
    },
    config = function(_, opts)
        local trouble = require("trouble")
        trouble.setup(opts)

        vim.keymap.set("n", "<leader>tt", function()
            trouble.toggle({ mode = "diagnostics" })
        end)

        vim.keymap.set("n", "]t", function()
            trouble.next({ skip_groups = true, jump = true });
        end)
        vim.keymap.set("n", "[t", function()
            trouble.prev({ skip_groups = true, jump = true });
        end)
    end
}
