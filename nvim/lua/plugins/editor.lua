return {
    {
        "nvim-tree/nvim-tree.lua",
        event = "BufReadPost",
        config = function()
            require("nvim-tree").setup()

            vim.keymap.set('n', '<leader>E', require('nvim-tree.api').tree.toggle,
                { noremap = true, silent = true, nowait = true })
        end
    },
    {
        "mbbill/undotree",
        event = "BufReadPost",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
        "Exafunction/codeium.vim",
        event = "BufReadPost",
        config = function()
            vim.keymap.set('i', '<Tab>', function() return vim.fn['codeium#Accept']() end, { expr = true })
            vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
        end
    },
    {
        "ThePrimeagen/harpoon",
        lazy = false,
        opts = {
            menu = {
                width = 90,
                height = 20
            }
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
                    string.format("<space>%s", i),
                    function()
                        require("harpoon.ui").nav_file(i)
                    end,
                    { desc = string.format("Harpoon navigate to file %s", i) }
                )
            end
        end,
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = true,
    },
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        config = function()
            require("Comment").setup({
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })
        end
    },
    {
        "EtiamNullam/deferred-clipboard.nvim",
        event = "BufReadPost",
        config = true,
    },
    {
        "m4xshen/smartcolumn.nvim",
        event = "BufReadPost",
        config = true,
    },
}
