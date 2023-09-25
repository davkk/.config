return {
    {
        dir = '~/.config/nvim/lua/plugins/custom/rose-pine-tinted',
        name = 'rose-pine',
        lazy = false,
        priority = 1000,
        opts = {
            dark_variant = 'main',
            bold_vert_split = true,
            dim_nc_background = false,

            disable_background = true,
            disable_float_background = true,
            disable_italics = true,
            highlight_groups = {
                WinSeparator = { bg = "None" },

                TabnineSuggestion = { fg = "muted", bg = "none", blend = 10 },

                CursorLine = { bg = "base", blend = 10 },
                CursorLineNr = { bold = true },
                LineNr = { fg = "highlight_med" },
                ColorColumn = { bg = "base", blend = 10 },

                DiagnosticWarn = { fg = "#ea9d34" },
                DiagnosticSignWarn = { link = "DiagnosticWarn" },
                DiagnosticVirtualTextWarn = { link = "DiagnosticWarn" },
                DiagnosticFloatingWarn = { link = "DiagnosticWarn" },

                DiagnosticUnderlineWarn = { sp = "#ea9d34" },

                GitSignsAdd = { bg = "None" },
                GitSignsChange = { bg = "None" },
                GitSignsDelete = { bg = "None" },

                FidgetTask = { fg = "highlight_med" },
                FidgetTitle = { fg = "text" },

                CmpItemMenu = { fg = "highlight_med" },
                CmpItemAbbrMatchFuzzy = { fg = "rose" },

                FloatTitle = { fg = "highlight_med" },
                FloatBorder = { fg = "highlight_med" },

                TabLine = { bg = "none", bold = true},
                TabLineFill = { bg = "none", fg = "muted", bold = true },
                TabLineSel = { bg = "none", fg = "rose", bold = true },
            }
        },
        config = function(_, opts)
            require("rose-pine").setup(opts)
            vim.cmd([[colorscheme rose-pine]])
        end,
    },
}
