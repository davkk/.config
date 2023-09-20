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

            local extend_filename = require('lualine.components.filename'):extend()
            extend_filename.apply_icon = require('lualine.components.filetype').apply_icon
            extend_filename.icon_hl_cache = {}

            local custom_filename = {
                extend_filename,
                color = { gui = "bold" },

                file_status = true,
                newfile_status = false,
                path = 1,

                shorting_target = 30,
            }

            return {
                options = {
                    icons_enabled = true,
                    theme = custom_rose_pine,
                    section_separators = "",
                    component_separators = "",
                    always_divide_middle = false,
                    globalstatus = true,
                },
                tabline = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        {
                            "tabs",
                            mode = 1,
                            tabs_color = {
                                active = { gui = "bold" },
                                inactive = { bg = "none", fg = "#908caa", gui = "bold" },
                            },
                            fmt = function(name, context)
                                return string.format("%s:[%s]", context.tabnr, name)
                            end,
                        },
                    },
                    lualine_x = {
                        {
                            "location",
                            color = { fg = "#908caa", gui = "bold" },
                            cond = function()
                                return vim.fn.winwidth(0) > 80
                            end
                        },
                    },
                    lualine_y = {},
                    lualine_z = {}
                },
                sections = {
                    lualine_a = {},
                    lualine_b = {
                        {
                            "branch",
                            icon = "",
                            color = { bg = "none", gui = "bold" },
                            padding = { right = 1 },
                            fmt = function(str)
                                local limit = 25
                                if #str > limit then
                                    return str:sub(1, limit) .. "…"
                                else
                                    return str
                                end
                            end,
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
                            cond = function()
                                return vim.fn.winwidth(0) > 80
                            end
                        },
                    },
                    lualine_c = {},
                    lualine_x = {
                        custom_filename,
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
