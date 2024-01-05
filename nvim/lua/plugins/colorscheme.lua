return {
    dir = "~/.config/nvim/lua/plugins/custom/rose-pine-tinted",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
        dark_variant = "main",
        bold_vert_split = true,
        dim_nc_background = false,
        disable_background = true,
        disable_float_background = false,
        disable_italics = true,
        highlight_groups = {
            Pmenu = { blend = 5 },
            PmenuSel = { bg = "rose", fg = "base" },

            StatusLine = { bg = "None" },
            WinSeparator = { bg = "None", fg = "overlay" },

            TabnineSuggestion = { fg = "muted", bg = "overlay", blend = 40 },

            CursorLine = { bg = "overlay", blend = 40 },
            CursorLineNr = { bold = true },
            LineNr = { fg = "highlight_med" },
            ColorColumn = { bg = "overlay", blend = 40 },

            SpellBad = { sp = "#ea9d34" },
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

            CmpItemMenu = { fg = "highlight_high" },
            CmpItemAbbrMatchFuzzy = { fg = "rose" },
            CmpItemKind = { fg = "iris" },

            NormalFloat = { blend = 5 },
            FloatTitle = { bg = "base", fg = "highlight_med", blend = 5 },
            FloatBorder = { fg = "highlight_med", blend = 5 },

            TelescopeNormal = { blend = 5 },
            TelescopeBorder = { blend = 5 },
            TelescopeTitle = { bg = "None", blend = 5 },
            TelescopeSelection = { bg = "highlight_med" },
            TelescopeSelectionCaret = { bg = "highlight_med" },

            TreesitterContext = { bg = "none", blend = 100 },
        }
    },
    config = function(_, opts)
        require("rose-pine").setup(opts)
        vim.cmd([[colorscheme rose-pine]])
    end,
}
