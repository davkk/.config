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
            {
                "ahmedkhalf/project.nvim",
                opts = {
                    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".editorconfig",
                        "global.json", "package-lock.json", "yarn.lock", "*.sln", "=src", ".env", "Cargo.toml" },
                    ignore_lsp = { "codeium", "lua_ls" },
                },
                config = function(_, opts) require("project_nvim").setup(opts) end,
            }
        },
        keys = {
            {
                "<C-e>",
                function()
                    require("telescope").extensions.file_browser.file_browser({
                        hidden = true,
                        -- path = "%:p:h",
                        -- cwd = vim.fn.expand("%:p:h"),
                        respect_gitignore = false,
                        initial_mode = "normal",
                    })
                end,
                desc = "Browse Files",
            },

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
                "<leader>d",
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
            telescope.load_extension("projects")
        end,
    },
}
