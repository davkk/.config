local diagnostics = {
    error = "#b4637a",
    warn = "#ea9d34",
    hint = "#907aa9",
    info = "#56949f",
}

require("rose-pine").setup {
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
        NormalFloat = { bg = "base", blend = 5 },
        FloatTitle = { bg = "base", blend = 5 },
        FloatBorder = { bg = "base", blend = 5 },

        LineNr = { fg = "highlight_med" },
        EndOfBuffer = { link = "LineNr" },
        WinSeparator = { link = "LineNr" },
        NonText = { link = "LineNr" },

        Comment = { fg = "highlight_high", italic = true },

        StatusLine = { fg = "highlight_high" },
        StatusLineTerm = { link = "StatusLine" },
        StatusLineTermNC = { link = "StatusLineNC" },

        ModeMsg = { link = "StatusLine" },
        TabLine = { link = "StatusLine" },

        WinBar = { link = "StatusLine" },
        WinBarNC = { link = "WinBar" },

        Pmenu = { bg = "base", blend = 5 },
        PmenuSel = { bg = "rose", fg = "base" },
        PmenuKindSel = { link = "PmenuSel" },
        PmenuExtraSel = { link = "PmenuSel" },
        PmenuExtra = { link = "Pmenu" },

        SpellCap = { sp = diagnostics.hint, undercurl = true },
        SpellBad = { sp = diagnostics.warn, undercurl = true },
        DiagnosticUnnecessary = { sp = diagnostics.hint, underline = true },

        QuickFixLine = { link = "CurSearch" },

        ["@type.qualifier"] = { fg = "subtle" },

        -- ibhagwan/fzf-lua
        FzfLuaBorder = { bg = "base", blend = 5 },

        -- nvim-treesitter/nvim-treesitter-context
        TreesitterContext = { link = "Normal" },
        TreesitterContextLineNumber = { bg = "none", fg = "highlight_high", bold = true },
        TreesitterContextSeparator = { link = "WinSeparator" },
    },

    before_highlight = function(name, highlight)
        -- replace curl with underline
        if highlight.undercurl and name:sub(1, 5) ~= "Spell" then
            highlight.undercurl = false
            highlight.underline = true
        end
    end,
}

vim.cmd.colorscheme "rose-pine"
