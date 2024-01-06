local M = {}

---@param options Options
function M._load(options)
    local h = require("rose-pine-tinted.util").highlight
    local p = require("rose-pine-tinted.palette")

    local groups = options.groups or {}
    local maybe = {
        base = (options.disable_background and p.none) or groups.background,
        surface = (options.disable_float_background and p.none) or groups.panel,
        italic = not options.disable_italics,
    }
    maybe.bold_vert_split = (options.bold_vert_split and groups.border) or p.none
    maybe.dim_nc_background = (options.dim_nc_background and groups.background_nc) or maybe.base

    local float_background = options.dim_nc_background
        and (options.disable_float_background and groups.panel_nc or groups.panel)
        or maybe.surface

    M.defaults = {
        ColorColumn = { bg = p.overlay, blend = 40 },
        Conceal = { bg = p.none },
        CurSearch = { link = "IncSearch" },
        Cursor = { fg = p.text, bg = p.highlight_high },
        CursorColumn = { bg = p.highlight_low },
        -- CursorIM = {},
        CursorLine = { bg = p.overlay, blend = 40 },
        CursorLineNr = { fg = p.text, bold = true },
        DarkenedPanel = { bg = maybe.surface },
        DarkenedStatusline = { bg = maybe.surface },
        DiffAdd = { bg = groups.git_add, blend = 20 },

        DiffChange = { bg = p.overlay },
        DiffDelete = { bg = groups.git_delete, blend = 20 },
        DiffText = { bg = groups.git_text, blend = 20 },
        diffAdded = { link = "DiffAdd" },
        diffChanged = { link = "DiffChange" },
        diffRemoved = { link = "DiffDelete" },
        Directory = { fg = p.foam, bg = p.none },
        -- EndOfBuffer = {},
        ErrorMsg = { fg = p.love, bold = true },
        FloatBorder = { fg = groups.border, bg = maybe.surface, blend = 5 },
        FloatTitle = { fg = p.highlight_med, bg = p.base, blend = 5 },
        FoldColumn = { fg = p.muted },
        Folded = { fg = p.text, bg = maybe.surface },
        IncSearch = { fg = groups.background, bg = p.rose },
        LineNr = { fg = p.highlight_med },
        MatchParen = { fg = p.text, bg = p.highlight_med },
        ModeMsg = { fg = p.subtle },
        MoreMsg = { fg = p.iris },
        NonText = { fg = p.muted },
        Normal = { fg = p.text, bg = maybe.base },
        NormalFloat = { fg = p.text, bg = maybe.surface, blend = 5 },
        NormalNC = { fg = p.text, bg = maybe.dim_nc_background },
        NvimInternalError = { fg = "#ffffff", bg = p.love },
        Pmenu = { fg = p.subtle, bg = maybe.surface, blend = 5 },
        PmenuSbar = { bg = p.highlight_low },
        PmenuSel = { fg = p.base, bg = p.rose },
        PmenuThumb = { bg = p.highlight_med },

        WinSeparator = { bg = p.none, fg = "overlay" },
        WinBar = { bg = p.none },
        WinBarNC = { bg = p.none },

        Question = { fg = p.gold },
        QuickFixLine = { bg = p.overlay },
        -- RedrawDebugNormal = {}
        RedrawDebugClear = { fg = "#ffffff", bg = p.gold },
        RedrawDebugComposed = { fg = "#ffffff", bg = p.pine },
        RedrawDebugRecompose = { fg = "#ffffff", bg = p.love },
        Search = { bg = p.highlight_med },
        SpecialKey = { fg = p.foam },
        SpellBad = { sp = p.warning, underline = true },
        SpellCap = { sp = p.subtle, underline = true },
        SpellLocal = { sp = p.subtle, underline = true },
        SpellRare = { sp = p.subtle, underline = true },
        SignColumn = {
            fg = p.text,
            bg = (options.dim_nc_background and p.none) or maybe.base,
        },
        Substitute = { fg = p.base, bg = p.love },
        StatusLine = { fg = p.subtle, bg = p.none },
        StatusLineNC = { fg = p.muted, bg = groups.panel_nc },
        StatusLineTerm = { link = "StatusLine" },
        StatusLineTermNC = { link = "StatusLineNC" },
        TabLine = { fg = p.subtle, bg = groups.panel },
        TabLineFill = { bg = groups.panel },
        TabLineSel = { fg = p.text, bg = p.overlay },
        Title = { fg = p.text },
        VertSplit = { fg = groups.border, bg = maybe.bold_vert_split },
        Visual = { bg = p.highlight_med },
        -- VisualNOS = {},
        WarningMsg = { fg = p.gold },
        -- Whitespace = {},
        WildMenu = { link = "IncSearch" },

        Boolean = { fg = p.rose },
        Character = { fg = p.gold },
        Comment = { fg = groups.comment, italic = maybe.italic },
        Conditional = { fg = p.pine },
        Constant = { fg = p.gold },
        Debug = { fg = p.rose },
        Define = { fg = p.iris },
        Delimiter = { fg = p.subtle },
        Error = { fg = p.love },
        Exception = { fg = p.pine },
        Float = { fg = p.gold },
        Function = { fg = p.rose },
        Identifier = { fg = p.rose },
        -- Ignore = {},
        Include = { fg = p.pine },
        Keyword = { fg = p.pine },
        Label = { fg = p.foam },
        Macro = { fg = p.iris },
        Number = { fg = p.gold },
        Operator = { fg = p.subtle },
        PreCondit = { fg = p.iris },
        PreProc = { fg = p.iris },
        Repeat = { fg = p.pine },
        Special = { fg = p.rose },
        SpecialChar = { fg = p.rose },
        SpecialComment = { fg = p.iris },
        Statement = { fg = p.pine },
        StorageClass = { fg = p.foam },
        String = { fg = p.gold },
        Structure = { fg = p.foam },
        Tag = { fg = p.foam },
        Todo = { fg = p.iris },
        Type = { fg = p.foam },
        Typedef = { link = "Type" },
        Underlined = { underline = true },

        htmlArg = { fg = p.iris },
        htmlBold = { bold = true },
        htmlEndTag = { fg = p.subtle },
        htmlH1 = { fg = groups.headings.h1, bold = true },
        htmlH2 = { fg = groups.headings.h2, bold = true },
        htmlH3 = { fg = groups.headings.h3, bold = true },
        htmlH4 = { fg = groups.headings.h4, bold = true },
        htmlH5 = { fg = groups.headings.h5, bold = true },
        htmlItalic = { italic = maybe.italic },
        htmlLink = { fg = groups.link },
        htmlTag = { fg = p.subtle },
        htmlTagN = { fg = p.text },
        htmlTagName = { fg = p.foam },

        markdownDelimiter = { fg = p.subtle },
        markdownH1 = { fg = groups.headings.h1, bold = true },
        markdownH1Delimiter = { link = "markdownH1" },
        markdownH2 = { fg = groups.headings.h2, bold = true },
        markdownH2Delimiter = { link = "markdownH2" },
        markdownH3 = { fg = groups.headings.h3, bold = true },
        markdownH3Delimiter = { link = "markdownH3" },
        markdownH4 = { fg = groups.headings.h4, bold = true },
        markdownH4Delimiter = { link = "markdownH4" },
        markdownH5 = { fg = groups.headings.h5, bold = true },
        markdownH5Delimiter = { link = "markdownH5" },
        markdownH6 = { fg = groups.headings.h6, bold = true },
        markdownH6Delimiter = { link = "markdownH6" },
        markdownLinkText = { fg = groups.link, sp = groups.link, underline = true },
        markdownUrl = { link = "markdownLinkText" },

        mkdCode = { fg = p.foam, italic = maybe.italic },
        mkdCodeDelimiter = { fg = p.rose },
        mkdCodeEnd = { fg = p.foam },
        mkdCodeStart = { fg = p.foam },
        mkdFootnotes = { fg = p.foam },
        mkdID = { fg = p.foam, underline = true },
        mkdInlineURL = { fg = groups.link, underline = true },
        mkdLink = { link = "mkdInlineURL" },
        mkdLinkDef = { link = "mkdInlineURL" },
        mkdListItemLine = { fg = p.text },
        mkdRule = { fg = p.subtle },
        mkdURL = { link = "mkdInlineURL" },

        DiagnosticError = { fg = groups.error },
        DiagnosticHint = { fg = groups.hint },
        DiagnosticInfo = { fg = groups.info },
        DiagnosticWarn = { fg = groups.warn },
        DiagnosticDefaultError = { fg = groups.error },
        DiagnosticDefaultHint = { fg = groups.hint },
        DiagnosticDefaultInfo = { fg = groups.info },
        DiagnosticDefaultWarn = { fg = groups.warn },
        DiagnosticFloatingError = { fg = groups.error },
        DiagnosticFloatingHint = { fg = groups.hint },
        DiagnosticFloatingInfo = { fg = groups.info },
        DiagnosticFloatingWarn = { fg = groups.warn },
        DiagnosticSignError = { fg = groups.error },
        DiagnosticSignHint = { fg = groups.hint },
        DiagnosticSignInfo = { fg = groups.info },
        DiagnosticSignWarn = { fg = groups.warn },
        DiagnosticStatusLineError = { fg = groups.error, bg = groups.panel },
        DiagnosticStatusLineHint = { fg = groups.hint, bg = groups.panel },
        DiagnosticStatusLineInfo = { fg = groups.info, bg = groups.panel },
        DiagnosticStatusLineWarn = { fg = groups.warn, bg = groups.panel },
        DiagnosticUnderlineError = { sp = groups.error, underline = true },
        DiagnosticUnderlineHint = { sp = groups.hint, underline = true },
        DiagnosticUnderlineInfo = { sp = groups.info, underline = true },
        DiagnosticUnderlineWarn = { sp = groups.warn, underline = true },
        DiagnosticVirtualTextError = { fg = groups.error },
        DiagnosticVirtualTextHint = { fg = groups.hint },
        DiagnosticVirtualTextInfo = { fg = groups.info },
        DiagnosticVirtualTextWarn = { fg = groups.warn },

        -- healthcheck
        healthError = { fg = groups.error },
        healthSuccess = { fg = groups.info },
        healthWarning = { fg = groups.warn },

        -- Treesitter
        ["@boolean"] = { link = "Boolean" },
        ["@character"] = { link = "Character" },
        ["@character.special"] = { link = "@character" },
        ["@class"] = { fg = p.foam },
        ["@comment"] = { link = "Comment" },
        ["@conditional"] = { link = "Conditional" },
        ["@constant"] = { link = "Constant" },
        ["@constant.builtin"] = { fg = p.love },
        ["@constant.macro"] = { link = "@constant" },
        ["@constructor"] = { fg = p.foam },
        ["@field"] = { fg = p.foam },
        ["@function"] = { link = "Function" },
        ["@function.builtin"] = { fg = p.love },
        ["@function.macro"] = { link = "@function" },
        ["@include"] = { link = "Include" },
        ["@interface"] = { fg = p.foam },
        ["@keyword"] = { link = "Keyword" },
        ["@keyword.operator"] = { fg = p.subtle },
        ["@label"] = { link = "Label" },
        ["@macro"] = { link = "Macro" },
        ["@method"] = { fg = p.rose },
        ["@number"] = { link = "Number" },
        ["@operator"] = { link = "Operator" },
        ["@parameter"] = { fg = p.iris, italic = maybe.italic },
        ["@preproc"] = { link = "PreProc" },
        ["@property"] = { fg = p.foam, italic = maybe.italic },
        ["@punctuation"] = { fg = groups.punctuation },
        ["@punctuation.bracket"] = { link = "@punctuation" },
        ["@punctuation.delimiter"] = { link = "@punctuation" },
        ["@punctuation.special"] = { link = "@punctuation" },
        ["@regexp"] = { link = "String" },
        ["@repeat"] = { link = "Repeat" },
        ["@storageclass"] = { link = "StorageClass" },
        ["@string"] = { link = "String" },
        ["@string.escape"] = { fg = p.pine },
        ["@string.special"] = { link = "@string" },
        ["@symbol"] = { link = "Identifier" },
        ["@tag"] = { link = "Tag" },
        ["@tag.attribute"] = { fg = p.iris },
        ["@tag.delimiter"] = { fg = p.subtle },
        ["@text"] = { fg = p.text },
        ["@text.strong"] = { bold = true },
        ["@text.emphasis"] = { italic = true },
        ["@text.underline"] = { underline = true },
        ["@text.strike"] = { strikethrough = true },
        ["@text.math"] = { link = "Special" },
        ["@text.environment"] = { link = "Macro" },
        ["@text.environment.name"] = { link = "Type" },
        ["@text.title"] = { link = "Title" },
        ["@text.uri"] = { fg = groups.link },
        ["@text.note"] = { link = "SpecialComment" },
        ["@text.warning"] = { fg = groups.warn },
        ["@text.danger"] = { fg = groups.error },
        ["@todo"] = { link = "Todo" },
        ["@type"] = { link = "Type" },
        ["@variable"] = { fg = p.text, italic = maybe.italic },
        ["@variable.builtin"] = { fg = p.love },
        ["@namespace"] = { link = "@include" },

        -- LSP Semantic Token Groups
        ["@lsp.type.comment"] = {},
        ["@lsp.type.enum"] = { link = "@type" },
        ["@lsp.type.keyword"] = { link = "@keyword" },
        ["@lsp.type.interface"] = { link = "@interface" },
        ["@lsp.type.namespace"] = { link = "@namespace" },
        ["@lsp.type.parameter"] = { link = "@parameter" },
        ["@lsp.type.property"] = { link = "@property" },
        ["@lsp.type.variable"] = {}, -- use treesitter styles for regular variables
        ["@lsp.typemod.function.defaultLibrary"] = { link = "Special" },
        ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },

        -- LSP Injected Groups
        ["@lsp.typemod.operator.injected"] = { link = "@operator" },
        ["@lsp.typemod.string.injected"] = { link = "@string" },
        ["@lsp.typemod.variable.injected"] = { link = "@variable" },

        -- nvim-treesitter Markdown Headings
        ["@text.title.1.markdown"] = { link = "markdownH1" },
        ["@text.title.1.marker.markdown"] = { link = "markdownH1Delimiter" },
        ["@text.title.2.markdown"] = { link = "markdownH2" },
        ["@text.title.2.marker.markdown"] = { link = "markdownH2Delimiter" },
        ["@text.title.3.markdown"] = { link = "markdownH3" },
        ["@text.title.3.marker.markdown"] = { link = "markdownH3Delimiter" },
        ["@text.title.4.markdown"] = { link = "markdownH4" },
        ["@text.title.4.marker.markdown"] = { link = "markdownH4Delimiter" },
        ["@text.title.5.markdown"] = { link = "markdownH5" },
        ["@text.title.5.marker.markdown"] = { link = "markdownH5Delimiter" },
        ["@text.title.6.markdown"] = { link = "markdownH6" },
        ["@text.title.6.marker.markdown"] = { link = "markdownH6Delimiter" },

        -- nvim-treesitter/nvim-treesitter-context
        TreesitterContext = { bg = p.none, blend = 100 },

        -- vim.lsp.buf.document_highlight()
        LspReferenceText = { bg = p.highlight_med },
        LspReferenceRead = { bg = p.highlight_med },
        LspReferenceWrite = { bg = p.highlight_med },

        -- lsp-highlight-codelens
        LspCodeLens = { fg = p.subtle },                  -- virtual text of code len
        LspCodeLensSeparator = { fg = p.highlight_high }, -- separator between two or more code len

        -- j-hui/fidget.nvim
        FidgetTask = { fg = p.highlight_med },
        FidgetTitle = { fg = p.text },

        -- lewis6991/gitsigns.nvim
        GitSignsAdd = { fg = groups.git_add, bg = p.none },
        GitSignsChange = { fg = groups.git_change, bg = p.none },
        GitSignsDelete = { fg = groups.git_delete, bg = p.none },
        SignAdd = { link = "GitSignsAdd" },
        SignChange = { link = "GitSignsChange" },
        SignDelete = { link = "GitSignsDelete" },

        -- hrsh7th/nvim-cmp
        CmpItemAbbr = { fg = p.subtle },
        CmpItemAbbrDeprecated = { fg = p.subtle, strikethrough = true },
        CmpItemAbbrMatch = { fg = p.text, bold = true },
        CmpItemAbbrMatchFuzzy = { fg = p.rose, bold = true },
        CmpItemKind = { fg = p.iris },
        CmpItemKindClass = { fg = p.pine },
        CmpItemKindFunction = { fg = p.rose },
        CmpItemKindInterface = { fg = p.foam },
        CmpItemKindMethod = { fg = p.iris },
        CmpItemKindSnippet = { fg = p.gold },
        CmpItemKindVariable = { fg = p.text },
        CmpItemMenu = { fg = p.highlight_high },

        -- nvim-telescope/telescope.nvim
        TelescopeBorder = { fg = groups.border, bg = float_background, blend = 5 },
        TelescopeMatching = { fg = p.rose },
        TelescopeNormal = { fg = p.subtle, bg = float_background, blend = 5 },
        TelescopePromptNormal = { fg = p.text, bg = float_background },
        TelescopePromptPrefix = { fg = p.subtle },
        TelescopeSelection = { fg = p.text, bg = p.highlight_med },
        TelescopeSelectionCaret = { fg = p.rose, bg = p.highlight_med },
        TelescopeTitle = { fg = p.subtle, bg = p.none, blend = 5 },

        -- rcarriga/nvim-dap-ui
        DapUIVariable = { link = "Normal" },
        DapUIValue = { link = "Normal" },
        DapUIFrameName = { link = "Normal" },
        DapUIThread = { fg = p.gold },
        DapUIWatchesValue = { link = "DapUIThread" },
        DapUIBreakpointsInfo = { link = "DapUIThread" },
        DapUIBreakpointsCurrentLine = { fg = p.gold, bold = true },
        DapUIWatchesEmpty = { fg = p.love },
        DapUIWatchesError = { link = "DapUIWatchesEmpty" },
        DapUIBreakpointsDisabledLine = { fg = p.muted },
        DapUISource = { fg = p.iris },
        DapUIBreakpointsPath = { fg = p.foam },
        DapUIScope = { link = "DapUIBreakpointsPath" },
        DapUILineNumber = { link = "DapUIBreakpointsPath" },
        DapUIBreakpointsLine = { link = "DapUIBreakpointsPath" },
        DapUIFloatBorder = { link = "DapUIBreakpointsPath" },
        DapUIStoppedThread = { link = "DapUIBreakpointsPath" },
        DapUIDecoration = { link = "DapUIBreakpointsPath" },
        DapUIModifiedValue = { fg = p.foam, bold = true },

        -- Exafunction/codeium.vim
        CodeiumSuggestion = { fg = p.muted, bg = p.overlay, blend = 40 },

        -- codota/tabnine.nvim
        TabnineSuggestion = { fg = p.muted, bg = p.overlay, blend = 40 },
    }

    vim.g.terminal_color_0 = p.overlay -- black
    vim.g.terminal_color_8 = p.subtle  -- bright black
    vim.g.terminal_color_1 = p.love    -- red
    vim.g.terminal_color_9 = p.love    -- bright red
    vim.g.terminal_color_2 = p.pine    -- green
    vim.g.terminal_color_10 = p.pine   -- bright green
    vim.g.terminal_color_3 = p.gold    -- yellow
    vim.g.terminal_color_11 = p.gold   -- bright yellow
    vim.g.terminal_color_4 = p.foam    -- blue
    vim.g.terminal_color_12 = p.foam   -- bright blue
    vim.g.terminal_color_5 = p.iris    -- magenta
    vim.g.terminal_color_13 = p.iris   -- bright magenta
    vim.g.terminal_color_6 = p.rose    -- cyan
    vim.g.terminal_color_14 = p.rose   -- bright cyan
    vim.g.terminal_color_7 = p.text    -- white
    vim.g.terminal_color_15 = p.text   -- bright white

    -- Set users highlight_group customisations.
    for group, opts in pairs(options.highlight_groups) do
        local default_opts = M.defaults[group]

        if (opts.inherit == nil or opts.inherit) and default_opts ~= nil then -- On merge.
            opts.inherit = nil                                                -- Don"t add this key to the highlight_group after merge.
            M.defaults[group] = vim.tbl_extend("force", default_opts, opts)
        else                                                                  -- On overwrite.
            opts.inherit = nil                                                -- Don"t add this key to the highlight_group.
            M.defaults[group] = opts
        end
    end

    -- Set highlights.
    for group, color in pairs(M.defaults) do
        h(group, color)
    end
end

return M
