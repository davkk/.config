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

                SpellBad = { underline = true, undercurl = false },
                SpellCap = { underline = true, undercurl = false },
                SpellLocal = { underline = true, undercurl = false },
                SpellRare = { underline = true, undercurl = false },

                DiagnosticWarn = { fg = "#ea9d34" },
                DiagnosticSignWarn = { link = "DiagnosticWarn" },
                DiagnosticVirtualTextWarn = { link = "DiagnosticWarn" },
                DiagnosticFloatingWarn = { link = "DiagnosticWarn" },

                DiagnosticUnderlineError = { underline = true, undercurl = false },
                DiagnosticUnderlineWarn = { underline = true, undercurl = false, sp = "#ea9d34" },
                DiagnosticUnderlineInfo = { underline = true, undercurl = false },
                DiagnosticUnderlineHint = { underline = true, undercurl = false },

                GitSignsAdd = { bg = "None" },
                GitSignsChange = { bg = "None" },
                GitSignsDelete = { bg = "None" },

                FidgetTask = { fg = "highlight_med" },
                FidgetTitle = { fg = "text" },

                CmpItemMenu = { fg = "highlight_med" },
                CmpItemAbbrMatchFuzzy = { fg = "rose" },

                FloatTitle = { fg = "highlight_med" },
                FloatBorder = { fg = "highlight_med" },
            }
        },
        config = function(_, opts)
            require("rose-pine").setup(opts)
            vim.cmd([[colorscheme rose-pine]])
        end,
    },
}
