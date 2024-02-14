return {
    -- {
    --     dir = "~/.config/nvim/lua/plugins/custom/rose-pine-tinted",
    --     name = "rose-pine-tinted",
    --     lazy = false,
    --     enabled = false,
    --     priority = 1000,
    --     config = function()
    --         require("rose-pine-tinted").setup()
    --         vim.cmd([[colorscheme rose-pine-tinted]])
    --     end,
    -- },
    {
        dir = "~/.config/nvim/lua/plugins/custom/fog.nvim",
        name = "fog",
        lazy = false,
        priority = 1000,
        config = function()
            require("fog").setup({
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
                    error = "#b4637a",
                    warning = "#ea9d34",
                    hint = "#907aa9",
                    info = "#56949f",
                },

                highlight_groups = {
                    -- line
                    CursorLine = { bg = "overlay", blend = 40 },
                    CursorLineNr = { fg = "text", bold = true },
                    LineNr = { fg = "highlight_med" },
                    ColorColumn = { bg = "overlay", blend = 40 },

                    -- menu
                    Pmenu = { blend = 5 },
                    PmenuSel = { bg = "rose", fg = "base" },

                    -- window
                    WinSeparator = { bg = "none", fg = "overlay" },
                    NormalFloat = { blend = 5 },
                    FloatTitle = { bg = "base", fg = "highlight_med", blend = 5 },
                    FloatBorder = { fg = "highlight_med", blend = 5 },

                    -- tabline
                    TabLine = { fg = "subtle", bg = "none" },
                    TabLineSel = { fg = "text", bg = "none", bold = true },
                    TabLineFill = { bg = "none" },

                    -- diagnostics
                    SpellBad = { sp = "#ea9d34" },
                    DiagnosticWarn = { fg = "#ea9d34" },
                    DiagnosticUnderlineWarn = { sp = "#ea9d34" },
                    DiagnosticSignWarn = { link = "DiagnosticWarn" },
                    DiagnosticVirtualTextWarn = { link = "DiagnosticWarn" },
                    DiagnosticFloatingWarn = { link = "DiagnosticWarn" },

                    -- search
                    Search = { link = "Visual" },

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
                    TelescopeBorder = { blend = 5 },
                    TelescopeTitle = { bg = "none", blend = 5 },
                    TelescopeSelection = { bg = "highlight_med" },
                    TelescopeSelectionCaret = { bg = "highlight_med" },

                    -- nvim-treesitter/nvim-treesitter-context
                    TreesitterContext = { bg = "none", link = "Normal" },

                    -- Exafunction/codeium.vim
                    CodeiumSuggestion = { fg = "muted", bg = "overlay", blend = 40 },

                    -- codota/tabnine.nvim
                    TabnineSuggestion = { fg = "muted", bg = "overlay", blend = 40 },
                },

                before_highlight = function(group, highlight, palette)
                    -- replace curl with underline
                    if highlight.undercurl then
                        highlight.undercurl = false
                        highlight.underline = true
                    end
                end,
            })
            vim.cmd([[colorscheme fog]])
        end,
    }
}
