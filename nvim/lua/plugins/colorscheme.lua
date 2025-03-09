local diagnostics = {
    error = "#b4637a",
    warn = "#ea9d34",
    hint = "#907aa9",
    info = "#56949f",
}

return {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
        variant = "moon",
        dark_variant = "moon",
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
            terminal = false,
            legacy_highlights = true,
            migrations = true,
        },

        styles = {
            bold = true,
            italic = false,
            transparency = true,
        },

        groups = {
            error = diagnostics.error,
            warn = diagnostics.warn,
            hint = diagnostics.hint,
            info = diagnostics.info,
        },

        highlight_groups = {
            LineNr = { fg = "highlight_med" },
            EndOfBuffer = { link = "LineNr" },
            Comment = { link = "LineNr" },
            WinSeparator = { link = "LineNr" },
            ModeMsg = { link = "LineNr" },

            StatusLineTerm = { link = "StatusLine" },
            StatusLineTermNC = { link = "StatusLineNC" },

            NormalFloat = { blend = 5 },
            FloatTitle = { bg = "base", fg = "highlight_med", blend = 5 },
            FloatBorder = { fg = "highlight_med", blend = 5 },

            WinBar = { bg = "none", fg = "highlight_high", bold = true },
            WinBarNC = { link = "WinBar" },

            Pmenu = { blend = 5 },
            PmenuSel = { bg = "rose", fg = "base" },
            PmenuKindSel = { link = "PmenuSel" },
            PmenuExtraSel = { link = "PmenuSel" },
            PmenuExtra = { link = "Pmenu" },

            SpellBad = { sp = diagnostics.warn },
            DiagnosticUnnecessary = { sp = diagnostics.hint, underline = true },

            QuickFixLine = { link = "CurSearch" },

            ["@type.qualifier"] = { fg = "subtle" },

            -- ibhagwan/fzf-lua
            FzfLuaBorder = { bg = "overlay", blend = 5 },

            -- nvim-treesitter/nvim-treesitter-context
            TreesitterContext = { link = "Normal" },
            TreesitterContextLineNumber = { bg = "none", fg = "highlight_high", bold = true },
            TreesitterContextSeparator = { link = "WinSeparator" },
        },

        before_highlight = function(_, highlight)
            -- replace curl with underline
            if highlight.undercurl then
                highlight.undercurl = false
                highlight.underline = true
            end
        end,
    },
    config = function(_, opts)
        require("rose-pine").setup(opts)
        vim.cmd.colorscheme "rose-pine"
    end,
}
