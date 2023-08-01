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

                CodeiumSuggestion = { fg = "muted" },

                CursorLine = { bg = "base", blend = 10 },
                CursorLineNr = { bold = true },
                LineNr = { fg = "highlight_med" },
                ColorColumn = { bg = "base", blend = 10 },

                SpellBad = { underline = true, undercurl = false },
                SpellCap = { underline = true, undercurl = false },
                SpellLocal = { underline = true, undercurl = false },
                SpellRare = { underline = true, undercurl = false },

                DiagnosticUnderlineError = { underline = true, undercurl = false },
                DiagnosticUnderlineHint = { underline = true, undercurl = false },
                DiagnosticUnderlineInfo = { underline = true, undercurl = false },
                DiagnosticUnderlineWarn = { underline = true, undercurl = false },

                GitSignsAdd = { bg = "None" },
                GitSignsChange = { bg = "None" },
                GitSignsDelete = { bg = "None" },

                FidgetTask = { fg = "highlight_med" },
                FidgetTitle = { fg = "text" },

                CmpItemKind = { link = "CmpItemMenuDefault" }
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
