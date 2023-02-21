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

            return {
                options = {
                    icons_enabled = true,
                    theme = custom_rose_pine,
                    component_separators = '',
                    section_separators = '',
                    disabled_filetypes = {
                        statusline = { "dashboard", "NvimTree", "Outline" },
                    },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = {
                        {
                            "branch",
                            icons_enabled = true,
                            icon = "",
                        },
                        {
                            "diff",
                            colored = true,
                            diff_color = {
                                added = { fg = "#6e6a86", bg = "None" },
                                modified = { fg = "#6e6a86", bg = "None" },
                                removed  = { fg = "#6e6a86", bg = "None" },
                            },
                            -- symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
                            cond = hide_in_width,
                        },
                    },
                    lualine_c = {},
                    lualine_x = { "%=" },
                    lualine_y = {
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            sections = { "error", "warn" },
                            symbols = { error = " ", warn = " ", hint = " ", info = " " },
                            colored = false,
                            update_in_insert = false,
                            always_visible = true,
                        }
                    },
                    lualine_z = {
                        {
                            function()
                                local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                                if buf_ft == "toggleterm" then return "" end
                                return buf_ft
                            end,
                        }
                    },
                },
            }
        end,
    },
}
