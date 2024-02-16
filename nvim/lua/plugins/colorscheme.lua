local my_palette = {
    _nc = "#19161f",
    surface = "#25222e",

    highlight_low = "#23222b",
    highlight_med = "#403e4e",
    highlight_high = "#545161",

    none = "none",

    base = "#1a1821",
    overlay = "#2f2b3b",
    muted = "#645c70",
    subtle = "#8d849a",
    text = "#dad6e9",
    love = "#f56389",
    gold = "#ffb083",
    rose = "#edb2b5",
    pine = "#628079",
    foam = "#b7d7d5",
    iris = "#d2b1d6",

    error = "#b4637a",
    warn = "#ea9d34",
    hint = "#907aa9",
    info = "#56949f",
}

local function tint(highlight, palette)
    if highlight.fg ~= nil then
        for name, color in pairs(palette) do
            if highlight.fg == color then
                highlight.fg = my_palette[name]
            end
        end
    end
    if highlight.bg ~= nil then
        for name, color in pairs(palette) do
            if highlight.bg == color then
                highlight.bg = my_palette[name]
            end
        end
    end
    if highlight.sp ~= nil then
        for name, color in pairs(palette) do
            if highlight.sp == color then
                highlight.sp = my_palette[name]
            end
        end
    end
end

return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
        variant = "main",      -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
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
            ModeMsg = { fg = "highlight_med", bold = true },

            -- statusline
            StatusLineTerm = { link = "StatusLine" },
            StatusLineTermNC = { link = "StatusLine" },

            -- tabline
            TabLine = { fg = "subtle", bg = "none" },
            TabLineSel = { fg = "text", bg = "none", bold = true },
            TabLineFill = { bg = "none" },

            -- diagnostics
            SpellBad = { sp = my_palette.warn },

            -- lsp
            ["@type.qualifier"] = { fg = "subtle" },
            ["@function.method.call"] = { fg = "rose" },

            -- search
            Search = { fg = "none", bg = "highlight_med" },
            CurSearch = { fg = "none", bg = "highlight_high" },

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

            -- Exafunction/codeium.vim
            CodeiumSuggestion = { fg = "muted", bg = "overlay", blend = 40 },

            -- codota/tabnine.nvim
            TabnineSuggestion = { fg = "muted", bg = "overlay", blend = 40 },
        },

        before_highlight = function(group, highlight, palette)
            -- custom color tint
            tint(highlight, palette)

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

        --- Terminal
        vim.g.terminal_color_0 = my_palette.overlay -- black
        vim.g.terminal_color_8 = my_palette.subtle  -- bright black
        vim.g.terminal_color_1 = my_palette.love    -- red
        vim.g.terminal_color_9 = my_palette.love    -- bright red
        vim.g.terminal_color_2 = my_palette.pine    -- green
        vim.g.terminal_color_10 = my_palette.pine   -- bright green
        vim.g.terminal_color_3 = my_palette.gold    -- yellow
        vim.g.terminal_color_11 = my_palette.gold   -- bright yellow
        vim.g.terminal_color_4 = my_palette.foam    -- blue
        vim.g.terminal_color_12 = my_palette.foam   -- bright blue
        vim.g.terminal_color_5 = my_palette.iris    -- magenta
        vim.g.terminal_color_13 = my_palette.iris   -- bright magenta
        vim.g.terminal_color_6 = my_palette.rose    -- cyan
        vim.g.terminal_color_14 = my_palette.rose   -- bright cyan
        vim.g.terminal_color_7 = my_palette.text    -- white
        vim.g.terminal_color_15 = my_palette.text   -- bright white
    end,
}
