return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "rose-pine-tinted" },
    lazy = false,
    opts = function()
        local palette = require("rose-pine-tinted.palette")

        local icon_filename = require("lualine.components.filename"):extend()
        icon_filename.apply_icon = require("lualine.components.filetype").apply_icon
        icon_filename.icon_hl_cache = {}

        return {
            options = {
                icons_enabled = true,
                theme = "rose-pine-tinted",
                section_separators = "",
                component_separators = "",
                globalstatus = true,
            },
            tabline = {
                lualine_a = {},
                lualine_b = {
                    {
                        "tabs",
                        show_modified_status = false,
                        max_length = vim.o.columns,
                        mode = 1,
                        tabs_color = {
                            active = { fg = palette.subtle },
                            inactive = { fg = palette.highlight_med },
                        },
                        fmt = function(name, context)
                            local active = context.current and "*" or " "
                            return string.format("%d:[%s]%s", context.tabnr, name, active)
                        end
                    },
                },
            },
            sections = {
                lualine_a = {},
                lualine_b = {
                    {
                        "mode",
                        padding = { left = 0, right = 2 },
                        color = { gui = "bold" },
                    },
                },
                lualine_c = {
                    {
                        icon_filename,
                        color = { fg = palette.subtle },

                        file_status = true,
                        newfile_status = true,
                        path = 1,

                        shorting_target = vim.o.columns * 1 / 3,
                    },
                    {
                        "diff",
                        colored = true,
                        padding = 1,
                        diff_color = {
                            added = { fg = palette.highlight_high, bg = palette.none },
                            modified = { fg = palette.highlight_high, bg = palette.none },
                            removed = { fg = palette.highlight_high, bg = palette.none },
                        },
                        cond = function() return vim.fn.winwidth(0) > 80 end
                    },
                },
                lualine_x = {
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        colored = true,
                        update_in_insert = false,
                        symbols = { error = "E", warn = "W", info = "I", hint = "H" },
                    },
                    {
                        "location",
                        color = { fg = palette.highlight_med },
                        padding = { left = 1, right = 0 },
                    }
                },
                lualine_y = {},
                lualine_z = {},
            },
        }
    end,
    config = function(_, opts)
        require("lualine").setup(opts)
        vim.o.showtabline = 1
    end
}
