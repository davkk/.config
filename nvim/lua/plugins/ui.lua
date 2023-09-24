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
            local icon_filename = require('lualine.components.filename'):extend()
            icon_filename.apply_icon = require('lualine.components.filetype').apply_icon
            icon_filename.icon_hl_cache = {}

            local custom_filename = {
                "filename",
                color = { gui = "bold" },

                file_status = true,
                newfile_status = true,
                path = 1,

                shorting_target = vim.o.columns * 1 / 3,
            }

            return {
                options = {
                    icons_enabled = true,
                    theme = "rose-pine",
                    section_separators = "",
                    component_separators = "",
                    globalstatus = true,
                },
                tabline = {
                    lualine_a = {},
                    lualine_b = {
                        {
                            "tabs",
                            max_length = vim.o.columns,
                            mode = 1,
                            padding = { left = 0, right = 1 },
                            tabs_color = {
                                active = { gui = "bold" },
                                inactive = { fg = "#8D849A", gui = "bold" },
                            },
                            fmt = function(_, context)
                                return string.format("(%s)", context.tabnr)
                            end,
                        },
                    },
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
                winbar = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { custom_filename },
                    lualine_x = {
                        {
                            "location",
                            color = { fg = "#8D849A", gui = "bold" },
                            padding = 0,
                        },
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
                inactive_winbar = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { custom_filename },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            separator = { left = "", right = "", },
                            padding = 0,
                        },
                    },
                    lualine_b = {
                        {
                            "branch",
                            icon = "",
                            color = { gui = "bold" },
                            padding = { left = 2, right = 1 },
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
                                added = { fg = "#8D849A", bg = "None" },
                                modified = { fg = "#8D849A", bg = "None" },
                                removed = { fg = "#8D849A", bg = "None" },
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
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            symbols = symbols,
                            colored = true,
                            update_in_insert = false,
                        },
                        {
                            "filetype",
                            color = { fg = "#8D849A", gui = "bold" },
                            colored = false,
                        }
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
            }
        end,
    },
}
