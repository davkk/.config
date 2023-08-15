return {
    {
        'rose-pine/neovim',
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

                TabnineSuggestion = { fg = "muted", bg = "none" },

                CursorLine = { bg = "base", blend = 10 },
                CursorLineNr = { bold = true },
                LineNr = { fg = "highlight_med" },
                ColorColumn = { bg = "base", blend = 10 },

                SpellBad = { underline = true, undercurl = false },
                SpellCap = { underline = true, undercurl = false },
                SpellLocal = { underline = true, undercurl = false },
                SpellRare = { underline = true, undercurl = false },

                DiagnosticError = { fg = "#e65656" },
                DiagnosticWarn = { fg = "#ea9d34" },
                DiagnosticInfo = { fg = "#56949f" },
                DiagnosticHint = { fg = "#79658F" },

                DiagnosticSignError = { link = "DiagnosticError" },
                DiagnosticSignWarn = { link = "DiagnosticWarn" },
                DiagnosticSignInfo = { link = "DiagnosticInfo" },
                DiagnosticSignHint = { link = "DiagnosticHint" },

                DiagnosticVirtualTextError = { link = "DiagnosticError" },
                DiagnosticVirtualTextWarn = { link = "DiagnosticWarn" },
                DiagnosticVirtualTextInfo = { link = "DiagnosticInfo" },
                DiagnosticVirtualTextHint = { link = "DiagnosticHint" },

                DiagnosticFloatingError = { link = "DiagnosticError" },
                DiagnosticFloatingWarn = { link = "DiagnosticWarn" },
                DiagnosticFloatingInfo = { link = "DiagnosticInfo" },
                DiagnosticFloatingHint = { link = "DiagnosticHint" },

                DiagnosticUnderlineError = { underline = true, undercurl = false, sp = "#e65656" },
                DiagnosticUnderlineWarn = { underline = true, undercurl = false, sp = "#ea9d34" },
                DiagnosticUnderlineInfo = { underline = true, undercurl = false, sp = "#56949f" },
                DiagnosticUnderlineHint = { underline = true, undercurl = false, sp = "#79658F" },

                GitSignsAdd = { bg = "None" },
                GitSignsChange = { bg = "None" },
                GitSignsDelete = { bg = "None" },

                FidgetTask = { fg = "highlight_med" },
                FidgetTitle = { fg = "text" },

                CmpItemKind = { link = "CmpItemMenuDefault" },

                FloatTitle = { fg = "highlight_med" },
                FloatBorder = { fg = "highlight_med" },
            }
        },
        config = function(_, opts)
            require("rose-pine").setup(opts)
            vim.cmd([[colorscheme rose-pine]])
        end,
    },
    -- {
    --     'ellisonleao/gruvbox.nvim',
    --     opts = {
    --         contrast = "hard", -- can be "hard", "soft" or empty string
    --         transparent_mode = true,
    --         italic = false,
    --         dim_inactive = true,
    --     }
    -- },
}
