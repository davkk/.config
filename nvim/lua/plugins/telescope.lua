return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = vim.fn.executable "make" == 1,
            },

            "ThePrimeagen/git-worktree.nvim",
        },
        keys = {
            {
                "<C-p>",
                function()
                    require("telescope.builtin").find_files()
                end,
                desc = "Find Files",
            },

            {
                "<leader>di",
                function()
                    require("telescope.builtin").diagnostics()
                end,
                desc = "Show Diagnostics",
            },

            {
                "<leader>gw", -- grep word
                function()
                    require("telescope.builtin").grep_string({
                        search = vim.fn.input "Grep String > ",
                    })
                end,
                desc = "Grep Word/String",
            },

            {
                "<leader>lg",
                function()
                    require("telescope.builtin").live_grep()
                end,
                desc = "Live Grep",
            },

            {
                "\\\\",
                function()
                    require("telescope.builtin").buffers()
                end,
                desc = "Show Buffers",
            },

            {
                "<leader>.",
                function()
                    require("telescope.builtin").find_files({
                        shorten_path = false,
                        cwd = "~/.config",
                        prompt_title = ".config files",
                        previewer = true,
                    })
                end,
                desc = "Edit .config Files",
            },

            {
                "<leader>wt",
                function()
                    require("telescope").extensions.git_worktree.git_worktrees()
                end,
                desc = "Git Worktree",
            },
        },
        opts = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    winblend = 5,
                    layout_strategy = "flex",
                    layout_config = {
                        prompt_position = "top",
                        width = 0.9,
                        height = 0.99,
                    },
                    path_display = { smart = true },
                    sorting_strategy = "ascending",
                    scroll_strategy = "cycle",
                    preview = { hide_on_startup = false },
                    results_title = false,
                    file_ignore_patterns = { "^.git/", "^.bare/" },
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
                pickers = {
                    find_files = {
                        previewer = false,
                        hidden = true,
                        path_display = { truncate = 5 }
                    },
                    buffers = {
                        initial_mode = "normal",
                        mappings = {
                            n = { ["dd"] = actions.delete_buffer, }
                        }
                    },
                    lsp_references = { initial_mode = "normal", },
                    grep_string = { initial_mode = "normal", },
                    diagnostics = { initial_mode = "normal", },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })

            telescope.load_extension("fzf")
            telescope.load_extension("git_worktree")
        end,
    },
}
