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
            local extend_filename = require('lualine.components.filename'):extend()
            extend_filename.apply_icon = require('lualine.components.filetype').apply_icon
            extend_filename.icon_hl_cache = {}

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
                    lualine_b = {},
                    lualine_c = {
                        {
                            extend_filename,
                            color = { gui = "bold" },

                            file_status = true,
                            newfile_status = true,
                            path = 3,

                            shorting_target = vim.o.columns * 3 / 5,
                        }
                    },
                    lualine_x = {},
                    lualine_y = {
                        {
                            "tabs",
                            max_length = vim.o.columns * 2 / 5,
                            mode = 1,
                            tabs_color = {
                                active = { gui = "bold" },
                                inactive = { fg = "#8D849A" },
                            },
                            fmt = function(name, context)
                                return string.format("%s: %s", context.tabnr, name)
                            end,
                            cond = function()
                                return #vim.api.nvim_list_tabpages() > 1
                            end
                        },
                    },
                    lualine_z = {}
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
                            "location",
                            color = { fg = "#8D849A", gui = "bold" },
                            cond = function()
                                return vim.fn.winwidth(0) > 80
                            end
                        },
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
            }
        end,
    },
}
