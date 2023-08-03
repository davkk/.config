return {
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = vim.fn.executable "make" == 1,
            },
            -- "nvim-telescope/telescope-file-browser.nvim",
            -- "nvim-telescope/telescope-ui-select.nvim",
        },
        keys = {
            -- {
            --     "<C-e>",
            --     function()
            --         require("telescope").extensions.file_browser.file_browser({
            --             hidden = true,
            --             path = "%:p:h",
            --             cwd = vim.fn.expand("%:p:h"),
            --             respect_gitignore = false,
            --             initial_mode = "normal",
            --             grouped = true,
            --         })
            --     end,
            --     desc = "Browse Files",
            -- },

            {
                "<C-p>",
                function()
                    require("telescope.builtin").find_files({
                        previewer = false,
                        hidden = true,
                        winblend = 9,
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
                "<leader>lg",
                function()
                    require("telescope.builtin").live_grep()
                end,
            },

            {
                "\\\\",
                function()
                    require 'telescope'.extensions.projects.projects({
                        initial_mode = "normal",
                    })
                end
            },
        },
        opts = function()
            local actions = require("telescope.actions")

            -- local fb_actions = require("telescope").extensions.file_browser.actions

            return {
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = {
                        mirror = true,
                        prompt_position = "top",
                        width = 0.6,
                        height = 30,
                    },
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
                    -- file_browser = {
                    --     hidden = true,
                    --     hijack_netrw = true,
                    --     file_ignore_patterns = { "^.git/", "^node_modules/", "^.vscode/" },
                    --     initial_mode = "normal",
                    --     mappings = {
                    --         ["n"] = {
                    --             ["%"] = fb_actions.create,
                    --             ["-"] = fb_actions.goto_parent_dir,
                    --             ["D"] = fb_actions.remove,
                    --             ["R"] = fb_actions.rename,
                    --             ["g."] = fb_actions.toggle_hidden,
                    --         },
                    --     },
                    -- },
                },
            }
        end,
        config = function(_, opts)
            local telescope = require("telescope")

            telescope.setup(opts)
            telescope.load_extension("fzf")
            -- telescope.load_extension("file_browser")
            -- telescope.load_extension("ui-select")
        end,
    },
}
