return {
    "nvim-tree/nvim-web-devicons",

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        opts = {
            char = '▏',
            context_char = '▏',
            show_current_context = true,
        },
        config = function(_, opts)
            require("indent_blankline").setup(opts)

            vim.cmd [[highlight IndentBlanklineChar guifg=#1f1d2e gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineContextChar guifg=#6e6a86 gui=nocombine]]
        end
    },

    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            local hide_in_width = function()
                return vim.fn.winwidth(0) > 80
            end

            local custom_rose_pine = require("lualine.themes.rose-pine")

            custom_rose_pine.normal.c.bg = "None"
            custom_rose_pine.insert.c.bg = "None"
            custom_rose_pine.visual.c.bg = "None"
            custom_rose_pine.command.c.bg = "None"
            custom_rose_pine.replace.c.bg = "None"

            local signs = require("plugins.lsp.utils").signs
            local symbols = {
                error = signs.Error,
                warn = signs.Warn,
                hint = signs.Hint,
                info = signs.Info,
            }

            return {
                options = {
                    icons_enabled = true,
                    theme = custom_rose_pine,
                    section_separators = "",
                    component_separators = "",
                    disabled_filetypes = {
                        statusline = { "dashboard", "NvimTree", "Outline" },
                    },
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            separator = { left = "", right = "", },
                            padding = 1,
                        }
                    },
                    lualine_b = {
                        {
                            "branch",
                            icons_enabled = true,
                            icon = "",
                            color = { bg = "none" },
                            padding = { left = 2, right = 1 },
                        },
                    },
                    lualine_c = {
                        {
                            "diff",
                            colored = true,
                            separator = { left = "", right = "", },
                            diff_color = {
                                added = { fg = "#6e6a86", bg = "None" },
                                modified = { fg = "#6e6a86", bg = "None" },
                                removed = { fg = "#6e6a86", bg = "None" },
                            },
                            symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
                            cond = hide_in_width,
                        },
                    },
                    lualine_x = {
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            symbols = symbols,
                            colored = true,
                            update_in_insert = true,
                        },
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
            }
        end,
    },
}
