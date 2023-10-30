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
                WinSeparator = { bg = "None", fg = "overlay" },

                TabnineSuggestion = { fg = "muted", bg = "overlay", blend = 40 },

                CursorLine = { bg = "overlay", blend = 40 },
                CursorLineNr = { bold = true },
                LineNr = { fg = "highlight_med" },
                ColorColumn = { bg = "overlay", blend = 40 },

                DiagnosticWarn = { fg = "#ea9d34" },
                DiagnosticUnderlineWarn = { sp = "#ea9d34" },
                DiagnosticSignWarn = { link = "DiagnosticWarn" },
                DiagnosticVirtualTextWarn = { link = "DiagnosticWarn" },
                DiagnosticFloatingWarn = { link = "DiagnosticWarn" },

                GitSignsAdd = { bg = "None" },
                GitSignsChange = { bg = "None" },
                GitSignsDelete = { bg = "None" },

                FidgetTask = { fg = "highlight_med" },
                FidgetTitle = { fg = "text" },

                CmpItemMenu = { fg = "highlight_low" },
                CmpItemAbbrMatchFuzzy = { fg = "rose" },
                CmpItemKind = { fg = "iris" },

                FloatTitle = { fg = "highlight_med" },
                FloatBorder = { fg = "highlight_med" },

                TelescopeSelection = { bg = "base" },
                TelescopeSelectionCaret = { bg = "base" },
            }
        },
        config = function(_, opts)
            require("rose-pine").setup(opts)
            vim.cmd([[colorscheme rose-pine]])
        end,
    },
}
