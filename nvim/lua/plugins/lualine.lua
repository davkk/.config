return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "rose-pine-tinted" },
    lazy = false,
    opts = function()
        local palette = require("rose-pine-tinted.palette")

        local icon_filename = require("lualine.components.filename"):extend()
        icon_filename.apply_icon = require("lualine.components.filetype").apply_icon
        icon_filename.icon_hl_cache = {}

        local custom_filename = {
            "filename",
            color = { fg = palette.subtle },

            file_status = true,
            newfile_status = true,
            path = 1,

            shorting_target = vim.o.columns * 1 / 3,
        }

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
                            active = { gui = "bold" },
                            inactive = { fg = palette.subtle, gui = "bold" },
                        },
                        fmt = function(name, context)
                            return string.format("%d:%s", context.tabnr, name)
                        end
                    },
                },
            },
            -- winbar = {
            --     lualine_a = {},
            --     lualine_b = {},
            --     lualine_c = { custom_filename },
            --     lualine_x = {
            --         {
            --             "location",
            --             color = { fg = palette.highlight_high, gui = "bold" },
            --             padding = 0,
            --         },
            --     },
            --     lualine_y = {},
            --     lualine_z = {},
            -- },
            -- inactive_winbar = {
            --     lualine_a = {},
            --     lualine_b = {},
            --     lualine_c = { custom_filename },
            --     lualine_x = {},
            --     lualine_y = {},
            --     lualine_z = {},
            -- },
            sections = {
                lualine_a = {},
                lualine_b = {
                    {
                        "mode",
                        padding = { left = 0, right = 1 },
                        color = { gui = "bold" },
                    },
                },
                lualine_c = {
                    custom_filename,
                    -- {
                    --     "branch",
                    --     icon = "󰜘",
                    --     padding = { left = 0, right = 2 },
                    --     color = { fg = palette.iris },
                    --     fmt = function(str)
                    --         local limit = 40
                    --         if #str > limit then
                    --             return str:sub(1, limit) .. "…"
                    --         else
                    --             return str
                    --         end
                    --     end,
                    -- },
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
                        color = { fg = palette.highlight_high },
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
