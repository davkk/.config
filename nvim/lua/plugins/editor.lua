return {
    {
        'stevearc/oil.nvim',
        keys = { "<C-e>" },
        opts = {
            columns = {
                "icon",
            },
            win_options = {
                wrap = false,
                signcolumn = "no",
                cursorcolumn = false,
                number = true,
                relativenumber = true,
                cursorline = true,
                foldcolumn = "0",
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = "n",
            },
            default_file_explorer = true,
            restore_win_options = true,
            skip_confirm_for_simple_edits = false,
            prompt_save_on_select_new_entry = true,
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<C-y>"] = "actions.select",
                ["<CR>"] = "actions.select",
                ["<C-v>"] = "actions.select_vsplit",
                ["<C-x>"] = "actions.select_split",
                ["<C-r>"] = "actions.refresh",
                ["<C-c>"] = "actions.close",
                ["q"] = "actions.close",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = "actions.tcd",
                ["g."] = "actions.toggle_hidden",
            },
            use_default_keymaps = false,
            view_options = {
                show_hidden = true,
            },
            float = {
                max_width = 80,
                max_height = 30,
                border = "rounded",
                win_options = {
                    winblend = 0,
                },
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function(_, opts) 
            local oil = require("oil")
            oil.setup(opts)

            vim.keymap.set("n", "<C-e>", oil.open, { noremap = true, silent = true })
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        keys = {
            "<leader>E",
        },
        config = function()
            require("nvim-tree").setup()

            vim.keymap.set('n', '<leader>E', require('nvim-tree.api').tree.toggle,
                { noremap = true, silent = true, nowait = true })
        end
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle },
        },
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
                    string.format("<leader>%s", i),
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
}
