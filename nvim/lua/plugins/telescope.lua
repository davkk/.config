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
            "nvim-telescope/telescope-file-browser.nvim",
        },
        keys = {
            {
                "<C-p>",
                function()
                    require("telescope.builtin").find_files({
                        previewer = false,
                        hidden = true,
                    })
                end,
                desc = "Find Files",
            },

            {
                "\\\\",
                function()
                    require("telescope.builtin").buffers({
                        buffer = 0,
                        initial_mode = "normal",
                    })
                end,
                desc = "Search Buffers"
            },

            {
                "<C-e>",
                function()
                    require("telescope").extensions.file_browser.file_browser({
                        hidden = true,
                        path = "%:p:h",
                        cwd = vim.fn.expand("%:p:h"),
                        respect_gitignore = false,
                        initial_mode = "normal",
                    })
                end,
                desc = "Browse Files",
            },

            {
                "]]",
                function()
                    require("telescope.builtin").diagnostics({
                        initial_mode = "normal",
                    })
                end
            },
        },
        opts = function()
            local actions = require("telescope.actions")

            local fb_actions = require("telescope").extensions.file_browser.actions

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
                            -- ['<esc>'] = actions.close,
                                ["<C-q>"] = actions.send_to_qflist,
                                ["<CR>"] = actions.select_default,
                        },
                        n = {
                                ["q"] = actions.close,
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
                    file_browser = {
                        hidden = true,
                        hijack_netrw = true,
                        file_ignore_patterns = { "^.git/", "^node_modules/", "^.vscode/" },
                        initial_mode = "normal",
                        mappings = {
                                ["n"] = {
                                    ["N"] = fb_actions.create,
                                    ["h"] = fb_actions.goto_parent_dir,
                                    ["/"] = function()
                                    vim.cmd("startinsert")
                                end
                            },
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            local telescope = require("telescope")

            telescope.setup(opts)
            telescope.load_extension("fzf")
            telescope.load_extension("file_browser")
        end,
    },
}
