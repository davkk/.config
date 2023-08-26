local symbols = {
    error = "󱎘 ",
    warn = "󱈸 ",
    hint = "󱠂 ",
    info = " ",
}

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        opts = function()
            local custom_rose_pine = require("lualine.themes.rose-pine")

            custom_rose_pine.normal.c.bg = "None"
            custom_rose_pine.insert.c.bg = "None"
            custom_rose_pine.visual.c.bg = "None"
            custom_rose_pine.command.c.bg = "None"
            custom_rose_pine.replace.c.bg = "None"

            local my_filename = require('lualine.components.filename'):extend()
            my_filename.apply_icon = require('lualine.components.filetype').apply_icon
            my_filename.icon_hl_cache = {}

            return {
                options = {
                    icons_enabled = true,
                    theme = custom_rose_pine,
                    section_separators = "",
                    component_separators = "",
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
                    lualine_x = {
                        {
                            "location",
                            color = { fg = "#6e6a86", gui = "bold" },
                        },
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
                sections = {
                    lualine_a = {},
                    lualine_b = {
                        {
                            "branch",
                            icon = "",
                            color = { bg = "none", gui = "bold" },
                            padding = { right = 1 },
                        },
                        {
                            "diff",
                            colored = true,
                            diff_color = {
                                added = { fg = "#908caa", bg = "None" },
                                modified = { fg = "#908caa", bg = "None" },
                                removed = { fg = "#908caa", bg = "None" },
                            },
                            symbols = {
                                added = " ",
                                modified = " ",
                                removed = " "
                            },
                            cond = function ()
                                return vim.fn.winwidth(0) > 80
                            end
                        },
                    },
                    lualine_c = {},
                    lualine_x = {
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            symbols = symbols,
                            colored = true,
                            update_in_insert = false,
                        },
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
            }
        end,
    },
}
