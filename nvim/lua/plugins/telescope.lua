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
                        hidden = true,
                        theme = "dropdown",
                        grouped = true,
                        previewer = false,
                        layout_config = { height = 30 },
                    })
                end,
                desc = "Find Files",
            },

            {
                "\\\\",
                function()
                    require("telescope.builtin").buffers({
                        buffer = 0
                    })
                end,
                desc = "Search Buffers"
            },

            {
                "<C-e>",
                function()
                    require("telescope").extensions.file_browser.file_browser({
                        path = "%:p:h",
                        cwd = vim.fn.expand("%:p:h"),
                        respect_gitignore = false,
                        hidden = true,
                        grouped = true,
                        initial_mode = "normal",
                    })
                end,
                desc = "Browse Files",
            },

            {
                "<leader>se",
                function()
                    require("telescope.builtin").diagnostics({
                        theme = "dropdown",
                        grouped = true,
                        layout_config = { height = 30 },
                    })
                end
            },
        },
        opts = function()
            local actions = require("telescope.actions")

            local fb_actions = require("telescope").extensions.file_browser.actions

            return {
                defaults = {
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
                        theme = "dropdown",
                        hidden = true,
                        hijack_netrw = true,
                        file_ignore_patterns = { "^.git/" },
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
