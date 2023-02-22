return {
    {
        'stevearc/oil.nvim',
        lazy = false,
        opts = {
            columns = {
                "icon",
                -- "size",
                -- "mtime",
            },
            keymaps = {
                ["q"] = "actions.close",
                ["<C-v>"] = "actions.select_vsplit",
            },
            float = {
                max_width = 100,
                max_height = 30,
                win_options = {
                    winblend = 0,
                },
            },
        },
        config = function(_, opts)
            local oil = require("oil")
            oil.setup(opts)

            vim.keymap.set("n", "-", oil.open_float, { desc = "Open parent directory" })
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
    { -- seamlessly navigate between nvim and tmux
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
        "abecodes/tabout.nvim",
        config = true,
        event = "InsertEnter",
        dependencies = { "nvim-treesitter" }, -- or require if not used so far
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
