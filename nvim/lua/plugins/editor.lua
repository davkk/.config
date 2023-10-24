return {
    {
        "stevearc/oil.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            columns = {
                {
                    "icon",
                    add_padding = false,
                },
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
                ["<C-t>"] = "actions.select_tab",
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
        config = function(_, opts)
            local oil = require("oil")
            oil.setup(opts)

            vim.keymap.set("n", "<C-e>", oil.open, { noremap = true, silent = true })
        end,
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle },
        },
    },
    {
        "codota/tabnine-nvim",
        event = "BufReadPost",
        build = "./dl_binaries.sh",
        opts = {
            disable_auto_comment = true,
            accept_keymap = "<Tab>",
            dismiss_keymap = "<C-x>",
            debounce_ms = 1000,
            exclude_filetypes = { "TelescopePrompt", "oil", "harpoon", "gitcommit" },
        },
        config = function(_, opts)
            require("tabnine").setup(opts)
        end,
    },
    {
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
        opts = {
            menu = {
                width = math.floor(vim.o.columns * 4 / 5),
                height = math.floor(vim.o.lines * 3 / 5),
            },
            excluded_filetypes = { "harpoon", "oil", "term" },
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
        "numToStr/Comment.nvim",
        event = "BufReadPost",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        config = function()
            require("Comment").setup({
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })
        end
    },
    {
        "tpope/vim-surround",
        event = "BufReadPost",
    },
    {
        "pappasam/nvim-repl",
        init = function()
            vim.g["repl_filetype_commands"] = {
                python = "ipython --no-autoindent",
            }
        end,
        keys = {
            { "<leader>rt", "<cmd>ReplToggle<cr>",  desc = "Toggle nvim-repl" },
            { "<leader>rc", "<cmd>ReplRunCell<cr>", desc = "nvim-repl run cell" },
        },
    },
    {
        "samjwill/nvim-unception",
        lazy = false,
        init = function()
            vim.g.unception_open_buffer_in_new_tab = true
        end
    }
}
