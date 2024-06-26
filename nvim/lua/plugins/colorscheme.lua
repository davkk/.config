local my_palette = {
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
            terminal = true,
            legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
            migrations = true,        -- Handle deprecated options automatically
        },

        styles = {
            bold = true,
            italic = false,
            transparency = true,
        },

        groups = {
            error = my_palette.error,
            warn = my_palette.warn,
            hint = my_palette.hint,
            info = my_palette.info,

            todo = "love",
        },

        highlight_groups = {
            -- line
            CursorLine = { bg = "base" },
            ColorColumn = { link = "CursorLine" },
            CursorLineNr = { fg = "text", bold = true },
            LineNr = { fg = "highlight_high" },
            EndOfBuffer = { link = "LineNr" },

            -- visual
            Visual = { bg = "highlight_med" },
            Comment = { link = "LineNr" },

            -- menu
            Pmenu = { blend = 5 },
            PmenuSel = { bg = "rose", fg = "base" },

            -- window
            WinSeparator = { bg = "none", fg = "overlay" },
            NormalFloat = { blend = 5 },
            FloatTitle = { bg = "base", fg = "highlight_med", blend = 5 },
            FloatBorder = { fg = "highlight_med", blend = 5 },
            -- ModeMsg = { fg = "highlight_med", bold = true },

            -- statusline
            StatusLine = { fg = "subtle" },
            StatusLineTerm = { link = "StatusLine" },
            StatusLineTermNC = { link = "StatusLine" },

            -- tabline
            TabLine = { fg = "subtle" },
            TabLineSel = { fg = "text", bg = "none" },
            TabLineFill = { bg = "none" },

            -- diagnostics
            SpellBad = { sp = my_palette.warn },
            DiagnosticUnnecessary = { fg = "muted", sp = my_palette.hint, underline = true },

            -- lsp
            ["@type.qualifier"] = { fg = "subtle" },
            ["@function.method.call"] = { fg = "rose" },

            -- quickfix list
            QuickFixLine = { bg = "text", blend = 15, bold = true },

            -- search
            Search = { fg = "none", bg = "highlight_med", blend = 75 },

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

            -- nvim-telescope/telescope.nvim
            TelescopeNormal = { blend = 5 },
            TelescopePromptNormal = { blend = 5 },
            TelescopeBorder = { blend = 5 },
            TelescopeTitle = { fg = "foam", bg = "foam", blend = 5, bold = false },
            TelescopeSelection = { bg = "highlight_med" },
            TelescopeSelectionCaret = { bg = "highlight_med", bold = true },

            -- nvim-treesitter/nvim-treesitter-context
            TreesitterContext = { bg = "none", link = "Normal" },
            TreesitterContextLineNumber = { bg = "none", fg = "highlight_high", bold = true },

            -- Exafunction/codeium.vim
            CodeiumSuggestion = { fg = "muted", bg = "overlay", blend = 40 },

            -- codota/tabnine.nvim
            TabnineSuggestion = { fg = "muted", bg = "overlay", blend = 40 },
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
