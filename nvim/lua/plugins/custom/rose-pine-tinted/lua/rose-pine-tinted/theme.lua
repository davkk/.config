local M = {}

---@param options Options
function M._load(options)
    local h = require("rose-pine-tinted.util").highlight
    local palette = require("rose-pine-tinted.palette")

    local groups = options.groups or {}
    local maybe = {
        base = (options.disable_background and palette.none) or groups.background,
        surface = (options.disable_float_background and palette.none) or groups.panel,
        italic = not options.disable_italics,
    }
    maybe.bold_vert_split = (options.bold_vert_split and groups.border) or palette.none
    maybe.dim_nc_background = (options.dim_nc_background and groups.background_nc) or maybe.base

    local float_background = options.dim_nc_background
        and (options.disable_float_background and groups.panel_nc or groups.panel)
        or maybe.surface

    M.defaults = {
        ColorColumn = { bg = palette.overlay, blend = 40 },
        Conceal = { bg = palette.none },
        CurSearch = { link = "IncSearch" },
        Cursor = { fg = palette.text, bg = palette.highlight_high },
        CursorColumn = { bg = palette.highlight_low },
        -- CursorIM = {},
        CursorLine = { bg = palette.overlay, blend = 40 },
        CursorLineNr = { fg = palette.text, bold = true },
        DarkenedPanel = { bg = maybe.surface },
        DarkenedStatusline = { bg = maybe.surface },
        DiffAdd = { bg = groups.git_add, blend = 20 },

        DiffChange = { bg = palette.overlay },
        DiffDelete = { bg = groups.git_delete, blend = 20 },
        DiffText = { bg = groups.git_text, blend = 20 },
        diffAdded = { link = "DiffAdd" },
        diffChanged = { link = "DiffChange" },
        diffRemoved = { link = "DiffDelete" },
        Directory = { fg = palette.foam, bg = palette.none, bold = true },
        -- EndOfBuffer = {},
        ErrorMsg = { fg = palette.love, bold = true },
        FloatBorder = { fg = groups.border, bg = maybe.surface, blend = 5 },
        FloatTitle = { fg = palette.highlight_med, bg = palette.base, blend = 5 },
        FoldColumn = { fg = palette.muted },
        Folded = { fg = palette.text, bg = maybe.surface },
        IncSearch = { fg = groups.background, bg = palette.rose },
        LineNr = { fg = palette.highlight_med },
        MatchParen = { fg = palette.text, bg = palette.highlight_med },
        ModeMsg = { fg = palette.subtle },
        MoreMsg = { fg = palette.iris },
        NonText = { fg = palette.muted },
        Normal = { fg = palette.text, bg = maybe.base },
        NormalFloat = { fg = palette.text, bg = maybe.surface, blend = 5 },
        NormalNC = { fg = palette.text, bg = maybe.dim_nc_background },
        NvimInternalError = { fg = "#ffffff", bg = palette.love },
        Pmenu = { fg = palette.subtle, bg = maybe.surface, blend = 5 },
        PmenuSbar = { bg = palette.highlight_low },
        PmenuSel = { fg = palette.base, bg = palette.rose },
        PmenuThumb = { bg = palette.highlight_med },

        WinSeparator = { bg = palette.none, fg = "overlay" },
        WinBar = { bg = palette.none },
        WinBarNC = { bg = palette.none },

        Question = { fg = palette.gold },
        QuickFixLine = { bg = palette.overlay },
        -- RedrawDebugNormal = {}
        RedrawDebugClear = { fg = "#ffffff", bg = palette.gold },
        RedrawDebugComposed = { fg = "#ffffff", bg = palette.pine },
        RedrawDebugRecompose = { fg = "#ffffff", bg = palette.love },
        Search = { bg = palette.highlight_med },
        SpecialKey = { fg = palette.foam },
        SpellBad = { sp = groups.warn, underline = true },
        SpellCap = { sp = palette.subtle, underline = true },
        SpellLocal = { sp = palette.subtle, underline = true },
        SpellRare = { sp = palette.subtle, underline = true },
        SignColumn = {
            fg = palette.text,
            bg = (options.dim_nc_background and palette.none) or maybe.base,
        },
        Substitute = { fg = palette.base, bg = palette.love },

        StatusLine = { fg = palette.subtle, bg = palette.none },
        StatusLineNC = { fg = palette.muted, bg = groups.panel_nc },
        StatusLineTerm = { link = "StatusLine" },
        StatusLineTermNC = { link = "StatusLineNC" },

        TabLine = { fg = palette.subtle, bg = palette.none },
        TabLineSel = { fg = palette.text, bg = palette.none, bold = true },
        TabLineFill = { bg = palette.none },

        Title = { fg = palette.text },
        VertSplit = { fg = groups.border, bg = maybe.bold_vert_split },
        Visual = { bg = palette.highlight_med },
        -- VisualNOS = {},
        WarningMsg = { fg = groups.warn },
        -- Whitespace = {},
        WildMenu = { link = "IncSearch" },

        Boolean = { fg = palette.rose },
        Character = { fg = palette.gold },
        Comment = { fg = groups.comment, italic = maybe.italic },
        Conditional = { fg = palette.pine },
        Constant = { fg = palette.gold },
        Debug = { fg = palette.rose },
        Define = { fg = palette.iris },
        Delimiter = { fg = palette.subtle },
        Error = { fg = palette.love },
        Exception = { fg = palette.pine },
        Float = { fg = palette.gold },
        Function = { fg = palette.rose },
        Identifier = { fg = palette.rose },
        -- Ignore = {},
        Include = { fg = palette.pine },
        Keyword = { fg = palette.pine },
        Label = { fg = palette.foam },
        Macro = { fg = palette.iris },
        Number = { fg = palette.gold },
        Operator = { fg = palette.subtle },
        PreCondit = { fg = palette.iris },
        PreProc = { fg = palette.iris },
        Repeat = { fg = palette.pine },
        Special = { fg = palette.rose },
        SpecialChar = { fg = palette.rose },
        SpecialComment = { fg = palette.iris },
        Statement = { fg = palette.pine },
        StorageClass = { fg = palette.foam },
        String = { fg = palette.gold },
        Structure = { fg = palette.foam },
        Tag = { fg = palette.foam },
        Todo = { fg = palette.todo, bg = palette.todo, blend = 20 },
        Type = { fg = palette.foam },
        Typedef = { link = "Type" },
        Underlined = { underline = true },

        htmlArg = { fg = palette.iris },
        htmlBold = { bold = true },
        htmlEndTag = { fg = palette.subtle },
        htmlH1 = { fg = groups.headings.h1, bold = true },
        htmlH2 = { fg = groups.headings.h2, bold = true },
        htmlH3 = { fg = groups.headings.h3, bold = true },
        htmlH4 = { fg = groups.headings.h4, bold = true },
        htmlH5 = { fg = groups.headings.h5, bold = true },
        htmlItalic = { italic = maybe.italic },
        htmlLink = { fg = groups.link },
        htmlTag = { fg = palette.subtle },
        htmlTagN = { fg = palette.text },
        htmlTagName = { fg = palette.foam },

        markdownDelimiter = { fg = palette.subtle },
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

        mkdCode = { fg = palette.foam, italic = maybe.italic },
        mkdCodeDelimiter = { fg = palette.rose },
        mkdCodeEnd = { fg = palette.foam },
        mkdCodeStart = { fg = palette.foam },
        mkdFootnotes = { fg = palette.foam },
        mkdID = { fg = palette.foam, underline = true },
        mkdInlineURL = { fg = groups.link, underline = true },
        mkdLink = { link = "mkdInlineURL" },
        mkdLinkDef = { link = "mkdInlineURL" },
        mkdListItemLine = { fg = palette.text },
        mkdRule = { fg = palette.subtle },
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
        --- Identifiers
        ["@variable"] = { fg = palette.text, italic = maybe.italic },
        ["@variable.builtin"] = { fg = palette.love },
        ["@variable.parameter"] = { fg = palette.iris, italic = maybe.italic },
        ["@variable.member"] = { fg = palette.foam },

        ["@constant"] = { fg = palette.gold },
        ["@constant.builtin"] = { fg = palette.love },
        ["@constant.macro"] = { fg = palette.gold },

        ["@module"] = { fg = palette.text },
        ["@module.builtin"] = { fg = palette.love },
        ["@label"] = { link = "Label" },

        --- Literals
        ["@string"] = { link = "String" },
        -- ["@string.documentation"] = {},
        ["@string.regexp"] = { fg = palette.iris },
        ["@string.escape"] = { fg = palette.pine },
        ["@string.special"] = { link = "String" },
        ["@string.special.symbol"] = { link = "Identifier" },
        ["@string.special.url"] = { fg = groups.link },
        -- ["@string.special.path"] = {},

        ["@character"] = { link = "Character" },
        ["@character.special"] = { link = "Character" },

        ["@boolean"] = { link = "Boolean" },
        ["@number"] = { link = "Number" },
        ["@number.float"] = { link = "Number" },

        --- Types
        ["@type"] = { fg = palette.foam },
        ["@type.builtin"] = { fg = palette.foam },
        -- ["@type.definition"] = {},
        -- ["@type.qualifier"] = {},

        -- ["@attribute"] = {},
        ["@property"] = { fg = palette.foam, italic = maybe.italic },

        --- Functions
        ["@function"] = { fg = palette.rose },
        ["@function.builtin"] = { fg = palette.love },
        -- ["@function.call"] = {},
        ["@function.macro"] = { link = "Function" },
        ["@function.method"] = { fg = palette.rose },
        ["@function.method.call"] = { fg = palette.rose },

        ["@constructor"] = { fg = palette.foam },
        ["@operator"] = { link = "Operator" },

        --- Keywords
        ["@keyword"] = { link = "Keyword" },
        -- ["@keyword.coroutine"] = {},
        -- ["@keyword.function"] = {},
        ["@keyword.operator"] = { fg = palette.subtle },
        ["@keyword.import"] = { fg = palette.pine },
        ["@keyword.storage"] = { fg = palette.foam },
        ["@keyword.repeat"] = { fg = palette.pine },
        ["@keyword.return"] = { fg = palette.pine },
        ["@keyword.debug"] = { fg = palette.rose },
        ["@keyword.exception"] = { fg = palette.pine },
        ["@keyword.conditional"] = { fg = palette.pine },
        ["@keyword.conditional.ternary"] = { fg = palette.pine },
        ["@keyword.directive"] = { fg = palette.iris },
        ["@keyword.directive.define"] = { fg = palette.iris },

        --- Punctuation
        ["@punctuation.delimiter"] = { fg = palette.subtle },
        ["@punctuation.bracket"] = { fg = palette.subtle },
        ["@punctuation.special"] = { fg = palette.subtle },

        --- Comments
        ["@comment"] = { link = "Comment" },
        -- ["@comment.documentation"] = {},

        ["@comment.error"] = { fg = groups.error },
        ["@comment.warning"] = { fg = groups.warn },
        ["@comment.todo"] = { fg = groups.todo, bg = groups.todo, blend = 20 },
        ["@comment.hint"] = { fg = groups.hint, bg = groups.hint, blend = 20 },
        ["@comment.info"] = { fg = groups.info, bg = groups.info, blend = 20 },
        ["@comment.note"] = { fg = groups.note, bg = groups.note, blend = 20 },

        --- Markup
        ["@markup.strong"] = { bold = true },
        ["@markup.italic"] = { italic = maybe.italic },
        ["@markup.strikethrough"] = { strikethrough = true },
        ["@markup.underline"] = { underline = true },

        ["@markup.heading"] = { fg = palette.foam, bold = true },

        ["@markup.quote"] = { fg = palette.subtle },
        ["@markup.math"] = { link = "Special" },
        ["@markup.environment"] = { link = "Macro" },
        ["@markup.environment.name"] = { link = "@type" },

        -- ["@markup.link"] = {},
        ["@markup.link.label"] = { fg = palette.text },
        ["@markup.link.url"] = { fg = groups.link },

        -- ["@markup.raw"] = { bg = palette.surface },
        -- ["@markup.raw.block"] = { bg = palette.surface },

        ["@markup.list"] = { fg = palette.text },
        ["@markup.list.checked"] = { fg = palette.foam, bg = palette.foam, blend = 10 },
        ["@markup.list.unchecked"] = { fg = palette.text },

        ["@diff.plus"] = { fg = groups.git_add, bg = groups.git_add, blend = 20 },
        ["@diff.minus"] = { fg = groups.git_delete, bg = groups.git_delete, blend = 20 },
        ["@diff.delta"] = { bg = groups.git_change, blend = 20 },

        ["@tag"] = { link = "Tag" },
        ["@tag.attribute"] = { fg = palette.iris },
        ["@tag.delimiter"] = { fg = palette.subtle },

        --- Non-highlighting captures
        -- ["@none"] = {},
        ["@conceal"] = { link = "Conceal" },

        -- ["@spell"] = {},
        -- ["@nospell"] = {},

        --- Semantic
        ["@lsp.type.comment"] = {},
        ["@lsp.type.enum"] = { link = "@type" },
        ["@lsp.type.interface"] = { link = "@interface" },
        ["@lsp.type.keyword"] = { link = "@keyword" },
        ["@lsp.type.namespace"] = { link = "@namespace" },
        ["@lsp.type.parameter"] = { link = "@parameter" },
        ["@lsp.type.property"] = { link = "@property" },
        ["@lsp.type.variable"] = {},
        ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
        ["@lsp.typemod.operator.injected"] = { link = "@operator" },
        ["@lsp.typemod.string.injected"] = { link = "@string" },
        ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
        ["@lsp.typemod.variable.injected"] = { link = "@variable" },

        ["@class"] = { fg = palette.foam },
        ["@conditional"] = { link = "Conditional" },
        ["@field"] = { fg = palette.foam },
        ["@include"] = { link = "Include" },
        ["@interface"] = { fg = palette.foam },
        ["@macro"] = { link = "Macro" },
        ["@method"] = { fg = palette.rose },
        ["@parameter"] = { fg = palette.iris, italic = maybe.italic },
        ["@preproc"] = { link = "PreProc" },
        ["@punctuation"] = { fg = groups.punctuation },
        ["@regexp"] = { link = "String" },
        ["@repeat"] = { link = "Repeat" },
        ["@storageclass"] = { link = "StorageClass" },
        ["@symbol"] = { link = "Identifier" },
        ["@text"] = { fg = palette.text },
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
        ["@text.reference"] = { fg = palette.subtle },
        ["@text.literal"] = { fg = palette.subtle },
        ["@markup"] = { link = "@text" },
        ["@markup.emphasis"] = { link = "@text.emphasis" },
        ["@markup.strike"] = { link = "@text.strike" },
        ["@markup.link"] = { link = "@text.reference" },
        ["@markup.raw"] = { link = "@text.literal" },
        ["@markup.note"] = { link = "@text.note" },
        ["@markup.warning"] = { link = "@text.warning" },
        ["@markup.danger"] = { link = "@text.danger" },
        ["@todo"] = { link = "Todo" },
        ["@namespace"] = { link = "@include" },

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
        ["@markup.heading.1.markdown"] = { link = "@text.title.1.markdown" },
        ["@markup.heading.1.marker.markdown"] = { link = "@text.title.1.marker.markdown" },
        ["@markup.heading.2.markdown"] = { link = "@text.title.2.markdown" },
        ["@markup.heading.2.marker.markdown"] = { link = "@text.title.2.marker.markdown" },
        ["@markup.heading.3.markdown"] = { link = "@text.title.3.markdown" },
        ["@markup.heading.3.marker.markdown"] = { link = "@text.title.3.marker.markdown" },
        ["@markup.heading.4.markdown"] = { link = "@text.title.4.markdown" },
        ["@markup.heading.4.marker.markdown"] = { link = "@text.title.4.marker.markdown" },
        ["@markup.heading.5.markdown"] = { link = "@text.title.5.markdown" },
        ["@markup.heading.5.marker.markdown"] = { link = "@text.title.5.marker.markdown" },
        ["@markup.heading.6.markdown"] = { link = "@text.title.6.markdown" },
        ["@markup.heading.6.marker.markdown"] = { link = "@text.title.6.marker.markdown" },

        -- nvim-treesitter/nvim-treesitter-context
        TreesitterContext = { bg = palette.none, link = "Normal" },

        -- vim.lsp.buf.document_highlight()
        LspReferenceText = { bg = palette.highlight_med },
        LspReferenceRead = { bg = palette.highlight_med },
        LspReferenceWrite = { bg = palette.highlight_med },

        -- lsp-highlight-codelens
        LspCodeLens = { fg = palette.subtle },                  -- virtual text of code len
        LspCodeLensSeparator = { fg = palette.highlight_high }, -- separator between two or more code len

        -- j-hui/fidget.nvim
        FidgetTask = { fg = palette.highlight_med },
        FidgetTitle = { fg = palette.text },

        -- lewis6991/gitsigns.nvim
        GitSignsAdd = { fg = groups.git_add, bg = palette.none },
        GitSignsChange = { fg = groups.git_change, bg = palette.none },
        GitSignsDelete = { fg = groups.git_delete, bg = palette.none },
        SignAdd = { link = "GitSignsAdd" },
        SignChange = { link = "GitSignsChange" },
        SignDelete = { link = "GitSignsDelete" },

        -- hrsh7th/nvim-cmp
        CmpItemAbbr = { fg = palette.subtle },
        CmpItemAbbrDeprecated = { fg = palette.subtle, strikethrough = true },
        CmpItemAbbrMatch = { fg = palette.text, bold = true },
        CmpItemAbbrMatchFuzzy = { fg = palette.rose, bold = true },
        CmpItemKind = { fg = palette.iris },
        CmpItemKindClass = { fg = palette.pine },
        CmpItemKindFunction = { fg = palette.rose },
        CmpItemKindInterface = { fg = palette.foam },
        CmpItemKindMethod = { fg = palette.iris },
        CmpItemKindSnippet = { fg = palette.gold },
        CmpItemKindVariable = { fg = palette.text },
        CmpItemMenu = { fg = palette.highlight_high },

        -- nvim-telescope/telescope.nvim
        TelescopeBorder = { fg = groups.border, bg = float_background, blend = 5 },
        TelescopeMatching = { fg = palette.rose },
        TelescopeNormal = { fg = palette.subtle, bg = float_background, blend = 5 },
        TelescopePromptNormal = { fg = palette.text, bg = float_background },
        TelescopePromptPrefix = { fg = palette.subtle },
        TelescopeSelection = { fg = palette.text, bg = palette.highlight_med },
        TelescopeSelectionCaret = { fg = palette.rose, bg = palette.highlight_med },
        TelescopeTitle = { fg = palette.subtle, bg = palette.none, blend = 5 },

        -- rcarriga/nvim-dap-ui
        DapUIVariable = { link = "Normal" },
        DapUIValue = { link = "Normal" },
        DapUIFrameName = { link = "Normal" },
        DapUIThread = { fg = palette.gold },
        DapUIWatchesValue = { link = "DapUIThread" },
        DapUIBreakpointsInfo = { link = "DapUIThread" },
        DapUIBreakpointsCurrentLine = { fg = palette.gold, bold = true },
        DapUIWatchesEmpty = { fg = palette.love },
        DapUIWatchesError = { link = "DapUIWatchesEmpty" },
        DapUIBreakpointsDisabledLine = { fg = palette.muted },
        DapUISource = { fg = palette.iris },
        DapUIBreakpointsPath = { fg = palette.foam },
        DapUIScope = { link = "DapUIBreakpointsPath" },
        DapUILineNumber = { link = "DapUIBreakpointsPath" },
        DapUIBreakpointsLine = { link = "DapUIBreakpointsPath" },
        DapUIFloatBorder = { link = "DapUIBreakpointsPath" },
        DapUIStoppedThread = { link = "DapUIBreakpointsPath" },
        DapUIDecoration = { link = "DapUIBreakpointsPath" },
        DapUIModifiedValue = { fg = palette.foam, bold = true },

        -- Exafunction/codeium.vim
        CodeiumSuggestion = { fg = palette.muted, bg = palette.overlay, blend = 40 },

        -- codota/tabnine.nvim
        TabnineSuggestion = { fg = palette.muted, bg = palette.overlay, blend = 40 },
    }

    vim.g.terminal_color_0 = palette.overlay -- black
    vim.g.terminal_color_8 = palette.subtle  -- bright black
    vim.g.terminal_color_1 = palette.love    -- red
    vim.g.terminal_color_9 = palette.love    -- bright red
    vim.g.terminal_color_2 = palette.pine    -- green
    vim.g.terminal_color_10 = palette.pine   -- bright green
    vim.g.terminal_color_3 = palette.gold    -- yellow
    vim.g.terminal_color_11 = palette.gold   -- bright yellow
    vim.g.terminal_color_4 = palette.foam    -- blue
    vim.g.terminal_color_12 = palette.foam   -- bright blue
    vim.g.terminal_color_5 = palette.iris    -- magenta
    vim.g.terminal_color_13 = palette.iris   -- bright magenta
    vim.g.terminal_color_6 = palette.rose    -- cyan
    vim.g.terminal_color_14 = palette.rose   -- bright cyan
    vim.g.terminal_color_7 = palette.text    -- white
    vim.g.terminal_color_15 = palette.text   -- bright white

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
