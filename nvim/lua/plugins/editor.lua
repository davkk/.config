return {
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
            vim.cmd([[ hi CodeiumSuggestion guifg=#6e6a86 ctermfg=8 ]])
        end
    },
    {
        "ThePrimeagen/harpoon",
        lazy = false,
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "add file to Harpoon" })
            vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "toggle Harpoon quick menu" })

            vim.keymap.set("n", "<C-j>", function() ui.nav_file(1) end, { desc = "navigate to first file in Harpoon" })
            vim.keymap.set("n", "<C-k>", function() ui.nav_file(2) end, { desc = "navigate to second file in Harpoon" })
            vim.keymap.set("n", "<C-l>", function() ui.nav_file(3) end, { desc = "navigate to third file in Harpoon" })
            vim.keymap.set("n", "<C-m>", function() ui.nav_file(4) end, { desc = "navigate to fourth file in Harpoon" })
        end,
    },
    {
        "gpanders/editorconfig.nvim",
        event = "BufReadPost"
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
