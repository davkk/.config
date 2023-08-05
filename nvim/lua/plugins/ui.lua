return {
    "nvim-tree/nvim-web-devicons",

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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

            local my_filename = require('lualine.components.filename'):extend()
            my_filename.apply_icon = require('lualine.components.filetype').apply_icon
            my_filename.icon_hl_cache = {}

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
                winbar = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        {
                            my_filename,
                            color = { gui = "bold" },

                            file_status = true,
                            newfile_status = false,
                            path = 1,

                            shorting_target = 40,
                        }
                    },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
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
                        {
                            "diff",
                            colored = true,
                            separator = { left = "", right = "", },
                            diff_color = {
                                added = { fg = "#6e6a86", bg = "None" },
                                modified = { fg = "#6e6a86", bg = "None" },
                                removed = { fg = "#6e6a86", bg = "None" },
                            },
                            symbols = {
                                added = " ",
                                modified = " ",
                                removed = " "
                            }, -- changes diff symbols
                            cond = hide_in_width,
                        },
                    },
                    lualine_c = {},
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
