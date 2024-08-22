local diagnostics = {
    error = "#b4637a",
    warn = "#ea9d34",
    hint = "#907aa9",
    info = "#56949f",
}

return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
        variant = "moon",      -- auto, main, moon, or dawn
        dark_variant = "moon", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
            terminal = false,
            legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
            migrations = true,        -- Handle deprecated options automatically
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
            todo = "love",
        },

        highlight_groups = {
            ColorColumn = { bg = "base" },
            CursorLine = { bg = "none" },
            CursorLineNr = { fg = "text", bold = true },
            LineNr = { fg = "highlight_high" },
            EndOfBuffer = { link = "LineNr" },

            Visual = { bg = "overlay" },
            Search = { fg = "none", bg = "highlight_med", blend = 75 },

            Comment = { link = "LineNr" },

            Pmenu = { blend = 5 },
            PmenuSel = { bg = "rose", fg = "base" },

            WinSeparator = { bg = "none", fg = "overlay" },

            NormalFloat = { blend = 5 },
            FloatTitle = { bg = "base", fg = "highlight_med", blend = 5 },
            FloatBorder = { fg = "highlight_med", blend = 5 },

            ModeMsg = { link = "LineNr" },

            StatusLine = { fg = "subtle" },
            StatusLineTerm = { link = "StatusLine" },
            StatusLineTermNC = { link = "StatusLine" },

            TabLine = { fg = "subtle" },
            TabLineSel = { fg = "text", bg = "none" },
            TabLineFill = { bg = "none" },

            SpellBad = { sp = diagnostics.warn },
            DiagnosticUnnecessary = { fg = "muted", sp = diagnostics.hint, underline = true },

            QuickFixLine = { bg = "text", blend = 15, bold = true },

            ["@type.qualifier"] = { fg = "subtle" },

            -- plugins

            -- lewis6991/gitsigns.nvim
            GitSignsAdd = { bg = "none" },
            GitSignsChange = { bg = "none" },
            GitSignsDelete = { bg = "none" },

            -- j-hui/fidget.nvim
            FidgetTask = { fg = "highlight_med" },
            FidgetTitle = { fg = "text" },

            -- hrsh7th/nvim-cmp
            CmpItemMenu = { fg = "highlight_high" },
            CmpItemAbbrMatchFuzzy = { fg = "rose" },
            CmpItemKind = { fg = "iris" },

            -- nvim-treesitter/nvim-treesitter-context
            TreesitterContext = { bg = "none", link = "Normal" },
            TreesitterContextLineNumber = { bg = "none", fg = "highlight_high", bold = true },
            TreesitterContextBottom = { underline = true, sp = "overlay" },

            -- Exafunction/codeium.vim
            CodeiumSuggestion = { fg = "muted", bg = "overlay", blend = 40 },

            -- codota/tabnine.nvim
            TabnineSuggestion = { fg = "muted", bg = "overlay", blend = 40 },

            -- folke/trouble.nvim
            TroubleNormal = { link = "Normal" },
            TroubleNormalNC = { link = "Normal" },
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
        vim.cmd([[colorscheme rose-pine]])
    end,
}
