return {
    {
        "Exafunction/codeium.vim",
        event = "BufReadPost",
        config = function()
            vim.keymap.set('i', '<C-y>', function() return vim.fn['codeium#Accept']() end, { expr = true })
            vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
            vim.cmd([[ hi CodeiumSuggestion guifg=#6e6a86 ctermfg=8 ]])
        end
    },
    {
        "ThePrimeagen/harpoon",
        lazy = false,
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            vim.keymap.set("n", "<leader>h", mark.add_file, { desc = "add file to Harpoon" })

            vim.keymap.set("n", "<leader>H", ui.toggle_quick_menu, { desc = "toggle Harpoon quick menu" })

            vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = "navigate to first file in Harpoon" })
            vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = "navigate to second file in Harpoon" })
            vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = "navigate to third file in Harpoon" })
            vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = "navigate to fourth file in Harpoon" })
            vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end, { desc = "navigate to fifth file in Harpoon" })
        end,
    },
    {
        "gpanders/editorconfig.nvim",
        event = "BufReadPost"
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    {
        -- seamlessly navigate between nvim and tmux
        "numToStr/Navigator.nvim",
        event = "VeryLazy",
        keys = {
            { "<A-h>", "<CMD>NavigatorLeft<CR>" },
            { "<A-l>", '<CMD>NavigatorRight<CR>' },
            { "<A-k>", '<CMD>NavigatorUp<CR>' },
            { "<A-j>", '<CMD>NavigatorDown<CR>' },
            { "<A-p>", '<CMD>NavigatorPrevious<CR>' },
        },
        config = true,
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = true,
    },
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = true,
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
