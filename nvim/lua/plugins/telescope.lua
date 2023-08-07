return {
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = {
            "stevearc/oil.nvim",
            { "nvim-lua/plenary.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = vim.fn.executable "make" == 1,
            },
            {
                "ThePrimeagen/git-worktree.nvim",
                opts = {
                    update_on_change_command = "Oil ."
                },
                config = function (_, opts)
                    require("git-worktree").setup(opts)
                end
            }
        },
        keys = {
            {
                "<C-p>",
                function()
                    require("telescope.builtin").find_files({
                        previewer = false,
                        hidden = true,
                        -- path = "%:p:h",
                        -- cwd = vim.fn.expand("%:p:h"),
                    })
                end,
                desc = "Find Files",
            },

            {
                "<leader>di",
                function()
                    require("telescope.builtin").diagnostics({
                        initial_mode = "normal",
                    })
                end
            },

            {
                "<leader>gw", -- grep word
                function()
                    require("telescope.builtin").grep_string({
                        search = vim.fn.input "Grep String > ",
                        initial_mode = "normal",
                    })
                end,
            },

            {
                "<leader>lg",
                function()
                    require("telescope.builtin").live_grep()
                end,
            },

            {
                "<leader>wt",
                function()
                    require('telescope').extensions.git_worktree.git_worktrees()
                end,
            },
        },
        opts = function()
            local actions = require("telescope.actions")

            return {
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = {
                        mirror = true,
                        prompt_position = "top",
                        width = 0.6,
                        height = 30,
                    },
                    path_display = { smart = true },
                    preview = { hide_on_startup = false },
                    results_title = false,
                    sorting_strategy = 'ascending',
                    file_ignore_patterns = { "^.git/" },
                    mappings = {
                        i = {
                            ["<C-y>"] = actions.select_default,
                            ["<C-d>"] = actions.results_scrolling_down,
                            ["<C-u>"] = actions.results_scrolling_up,
                        },
                        n = {
                            ["q"] = actions.close,
                            ["<C-c>"] = actions.close,
                            ["<C-y>"] = actions.select_default,
                            ["<C-d>"] = actions.results_scrolling_down,
                            ["<C-u>"] = actions.results_scrolling_up,
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            }
        end,
        config = function(_, opts)
            local telescope = require("telescope")

            telescope.setup(opts)
            telescope.load_extension("fzf")
            telescope.load_extension("git_worktree")
        end,
    },
}
