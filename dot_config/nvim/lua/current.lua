---@class Cloud
---@field config CloudConfig
---@field palette CloudPalette
local Cloud = {}

---@class ItalicConfig
---@field strings boolean
---@field comments boolean
---@field operators boolean
---@field folds boolean
---@field emphasis boolean

---@class HighlightDefinition
---@field fg string?
---@field bg string?
---@field sp string?
---@field blend integer?
---@field bold boolean?
---@field standout boolean?
---@field underline boolean?
---@field undercurl boolean?
---@field underdouble boolean?
---@field underdotted boolean?
---@field strikethrough boolean?
---@field italic boolean?
---@field reverse boolean?
---@field nocombine boolean?

---@class CloudConfig
---@field bold boolean?
---@field dim_inactive boolean?
---@field inverse boolean?
---@field invert_selection boolean?
---@field invert_signs boolean?
---@field invert_tabline boolean?
---@field italic ItalicConfig?
---@field overrides table<string, HighlightDefinition>?
---@field palette_overrides table<string, string>?
---@field strikethrough boolean?
---@field terminal_colors boolean?
---@field transparent_mode boolean?
---@field undercurl boolean?
---@field underline boolean?

local default_config = {
    terminal_colors = true,
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    inverse = true,
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
}

Cloud.config = vim.deepcopy(default_config)

---@class CloudPalette
---@field bg string
---@field lightbg string
---@field fg string
---@field gray string
---@field midgray string
---@field navy string
---@field blue string
---@field func_orange string
---@field green string
---@field amber string
---@field orange string
---@field red string
---@field purple string
---@field teal string
---@field accent string
---@field selection string
---@field selection_text string
Cloud.palette = {
    bg = "#f5f5f5",
    lightbg = "#ededed",
    fg = "#454545",
    gray = "#919aa1",
    midgray = "#777777",
    navy = "#00638a",
    blue = "#008abd",
    func_orange = "#bf7000",
    green = "#678f03",
    amber = "#cc6d00",
    orange = "#bf7000",
    red = "#d0372d",
    purple = "#7d57c2",
    teal = "#008080",
    accent = "#008abd",
    selection = "#b8e4f8",
    selection_text = "#2b2b2b",
}

-- Build the single (light) color table.
local function get_colors()
    local p = Cloud.palette
    local config = Cloud.config

    -- allow user overrides of the raw palette
    for color, hex in pairs(config.palette_overrides) do
        p[color] = hex
    end

    -- Option 1.B: map Cloud palette → Gruvbox-style slots
    local colors = {
        -- backgrounds (light scheme)
        bg0 = p.bg,
        bg1 = p.lightbg,
        bg2 = p.lightbg,
        bg3 = p.selection,
        bg4 = p.midgray,

        -- foregrounds
        fg0 = p.fg,
        fg1 = p.fg,
        fg2 = p.midgray,
        fg3 = p.gray,
        fg4 = p.gray,

        -- accents
        red = p.red,
        green = p.green,
        yellow = p.amber,
        blue = p.blue,
        purple = p.purple,
        aqua = p.teal,
        orange = p.orange,

        -- neutrals (kept for plugin compatibility)
        neutral_red = p.red,
        neutral_green = p.green,
        neutral_yellow = p.amber,
        neutral_blue = p.blue,
        neutral_purple = p.purple,
        neutral_aqua = p.teal,

        gray = p.gray,

        -- Cloud-specific semantic colors
        navy = p.navy,
        accent = p.accent or p.blue,
        func = p.func_orange,
        func_orange = p.func_orange,
        selection = p.selection,
        selection_text = p.selection_text,
    }

    return colors
end

local function get_groups()
    local colors = get_colors()
    local config = Cloud.config

    -- terminal colors for light scheme
    if config.terminal_colors then
        local term_colors = {
            colors.bg0,
            colors.neutral_red,
            colors.neutral_green,
            colors.neutral_yellow,
            colors.neutral_blue,
            colors.neutral_purple,
            colors.neutral_aqua,
            colors.fg4,
            colors.gray,
            colors.red,
            colors.green,
            colors.yellow,
            colors.blue,
            colors.purple,
            colors.aqua,
            colors.fg1,
        }
        for index, value in ipairs(term_colors) do
            vim.g["terminal_color_" .. index - 1] = value
        end
    end

    local groups = {
        -- base Cloud “named” groups (like GruvboxFg0, etc.)
        CloudFg0                      = { fg = colors.fg0 },
        CloudFg1                      = { fg = colors.fg1 },
        CloudFg2                      = { fg = colors.fg2 },
        CloudFg3                      = { fg = colors.fg3 },
        CloudFg4                      = { fg = colors.fg4 },
        CloudWhite                    = { fg = colors.fg0 },
        CloudGray                     = { fg = colors.gray },
        CloudBg0                      = { fg = colors.bg0 },
        CloudBg1                      = { fg = colors.bg1 },
        CloudBg2                      = { fg = colors.bg2 },
        CloudBg3                      = { fg = colors.bg3 },
        CloudBg4                      = { fg = colors.bg4 },
        CloudRed                      = { fg = colors.red },
        CloudRedBold                  = { fg = colors.red, bold = config.bold },
        CloudGreen                    = { fg = colors.green },
        CloudGreenBold                = { fg = colors.green, bold = config.bold },
        CloudYellow                   = { fg = colors.yellow },
        CloudYellowBold               = { fg = colors.yellow, bold = config.bold },
        CloudBlue                     = { fg = colors.blue },
        CloudBlueBold                 = { fg = colors.blue, bold = config.bold },
        CloudPurple                   = { fg = colors.purple },
        CloudPurpleBold               = { fg = colors.purple, bold = config.bold },
        CloudAqua                     = { fg = colors.aqua },
        CloudAquaBold                 = { fg = colors.aqua, bold = config.bold },
        CloudOrange                   = { fg = colors.orange },
        CloudOrangeBold               = { fg = colors.orange, bold = config.bold },

        -- signs (respect transparent_mode + invert_signs)
        CloudRedSign                  = config.transparent_mode and { fg = colors.red, reverse = config.invert_signs }
            or { fg = colors.red, bg = colors.bg0, reverse = config.invert_signs },
        CloudGreenSign                = config.transparent_mode and { fg = colors.green, reverse = config.invert_signs }
            or { fg = colors.green, bg = colors.bg0, reverse = config.invert_signs },
        CloudYellowSign               = config.transparent_mode and { fg = colors.yellow, reverse = config.invert_signs }
            or { fg = colors.yellow, bg = colors.bg0, reverse = config.invert_signs },
        CloudBlueSign                 = config.transparent_mode and { fg = colors.blue, reverse = config.invert_signs }
            or { fg = colors.blue, bg = colors.bg0, reverse = config.invert_signs },
        CloudPurpleSign               = config.transparent_mode and { fg = colors.purple, reverse = config.invert_signs }
            or { fg = colors.purple, bg = colors.bg0, reverse = config.invert_signs },
        CloudAquaSign                 = config.transparent_mode and { fg = colors.aqua, reverse = config.invert_signs }
            or { fg = colors.aqua, bg = colors.bg0, reverse = config.invert_signs },
        CloudOrangeSign               = config.transparent_mode and { fg = colors.orange, reverse = config.invert_signs }
            or { fg = colors.orange, bg = colors.bg0, reverse = config.invert_signs },

        CloudRedUnderline             = { undercurl = config.undercurl, sp = colors.red },
        CloudGreenUnderline           = { undercurl = config.undercurl, sp = colors.green },
        CloudYellowUnderline          = { undercurl = config.undercurl, sp = colors.yellow },
        CloudBlueUnderline            = { undercurl = config.undercurl, sp = colors.blue },
        CloudPurpleUnderline          = { undercurl = config.undercurl, sp = colors.purple },
        CloudAquaUnderline            = { undercurl = config.undercurl, sp = colors.aqua },
        CloudOrangeUnderline          = { undercurl = config.undercurl, sp = colors.orange },

        -- core editor
        Normal                        = config.transparent_mode and { fg = colors.fg1, bg = nil } or
        { fg = colors.fg1, bg = colors.bg0 },
        NormalFloat                   = config.transparent_mode and { fg = colors.fg1, bg = nil } or
        { fg = colors.fg1, bg = colors.bg1 },
        NormalNC                      = config.dim_inactive and { fg = colors.fg3, bg = colors.bg1 } or
        { link = "Normal" },

        CursorLine                    = { bg = colors.bg1 },
        CursorColumn                  = { link = "CursorLine" },
        ColorColumn                   = { bg = colors.bg1 },
        MatchParen                    = { fg = colors.red, bold = config.bold },

        TabLineFill                   = { fg = colors.bg4, bg = colors.bg1, reverse = config.invert_tabline },
        TabLineSel                    = { fg = colors.blue, bg = colors.bg1, reverse = config.invert_tabline },
        TabLine                       = { link = "TabLineFill" },

        Conceal                       = { fg = colors.blue },
        CursorLineNr                  = { fg = colors.yellow, bg = colors.bg1 },
        NonText                       = { link = "CloudBg2" },
        SpecialKey                    = { link = "CloudFg4" },

        -- Option 3.B: Visual uses selection; Search uses inverse
        Visual                        = { bg = colors.selection, reverse = config.invert_selection },
        VisualNOS                     = { link = "Visual" },
        Search                        = { fg = colors.yellow, bg = colors.bg0, reverse = config.inverse },
        IncSearch                     = { fg = colors.orange, bg = colors.bg0, reverse = config.inverse },
        CurSearch                     = { link = "IncSearch" },
        QuickFixLine                  = { link = "CloudPurple" },

        Underlined                    = { fg = colors.blue, underline = config.underline },

        StatusLine                    = { fg = colors.fg1, bg = colors.bg2 },
        StatusLineNC                  = { fg = colors.fg4, bg = colors.bg1 },
        WinBar                        = { fg = colors.fg4, bg = colors.bg0 },
        WinBarNC                      = { fg = colors.fg3, bg = colors.bg1 },
        WinSeparator                  = config.transparent_mode and { fg = colors.bg3, bg = nil } or
        { fg = colors.bg3, bg = colors.bg0 },
        WildMenu                      = { fg = colors.blue, bg = colors.bg2, bold = config.bold },

        Directory                     = { link = "CloudGreenBold" },
        Title                         = { link = "CloudGreenBold" },
        ErrorMsg                      = { fg = colors.bg0, bg = colors.red, bold = config.bold },
        MoreMsg                       = { link = "CloudYellowBold" },
        ModeMsg                       = { link = "CloudYellowBold" },
        Question                      = { link = "CloudOrangeBold" },
        WarningMsg                    = { link = "CloudRedBold" },

        LineNr                        = { fg = colors.gray },
        SignColumn                    = config.transparent_mode and { bg = nil } or { bg = colors.bg0 },
        Folded                        = { fg = colors.gray, bg = colors.bg1, italic = config.italic.folds },
        FoldColumn                    = config.transparent_mode and { fg = colors.gray, bg = nil } or
        { fg = colors.gray, bg = colors.bg1 },

        Cursor                        = { reverse = config.inverse },
        vCursor                       = { link = "Cursor" },
        iCursor                       = { link = "Cursor" },
        lCursor                       = { link = "Cursor" },

        -- core syntax (Cloud semantics)
        Special                       = { link = "CloudOrange" },
        Comment                       = { fg = colors.gray, italic = config.italic.comments },
        Todo                          = { fg = colors.purple, bold = config.bold, italic = config.italic.comments },
        Done                          = { fg = colors.orange, bold = config.bold, italic = config.italic.comments },

        Error                         = { fg = colors.red, bold = config.bold, reverse = config.inverse },

        Statement                     = { fg = colors.navy },
        Conditional                   = { fg = colors.navy },
        Repeat                        = { fg = colors.navy },
        Label                         = { fg = colors.navy },
        Exception                     = { fg = colors.red },

        Operator                      = { fg = colors.gray, italic = config.italic.operators },
        Keyword                       = { fg = colors.navy, bold = config.bold },

        Identifier                    = { fg = colors.fg1 },
        Function                      = { fg = colors.func, bold = config.bold },

        PreProc                       = { fg = colors.blue },
        Include                       = { fg = colors.navy, bold = config.bold },
        Define                        = { fg = colors.navy },
        Macro                         = { fg = colors.blue },
        PreCondit                     = { fg = colors.blue },

        Constant                      = { fg = colors.yellow },
        Character                     = { fg = colors.midgray },
        String                        = { fg = colors.green, italic = config.italic.strings },
        Boolean                       = { fg = colors.aqua },
        Number                        = { fg = colors.yellow },
        Float                         = { fg = colors.yellow },

        Type                          = { fg = colors.navy, bold = config.bold },
        StorageClass                  = { fg = colors.blue },
        Structure                     = { fg = colors.blue },
        Typedef                       = { fg = colors.navy },

        Pmenu                         = { fg = colors.fg1, bg = colors.bg2 },
        PmenuSel                      = { fg = colors.bg0, bg = colors.blue, bold = config.bold },
        PmenuSbar                     = { bg = colors.bg2 },
        PmenuThumb                    = { bg = colors.bg4 },

        DiffDelete                    = { fg = colors.red },
        DiffAdd                       = { fg = colors.green },
        DiffChange                    = { fg = colors.orange },
        DiffText                      = { fg = colors.orange },

        SpellCap                      = { link = "CloudBlueUnderline" },
        SpellBad                      = { link = "CloudRedUnderline" },
        SpellLocal                    = { link = "CloudAquaUnderline" },
        SpellRare                     = { link = "CloudPurpleUnderline" },

        Whitespace                    = { fg = colors.bg2 },
        Delimiter                     = { fg = colors.fg1 },
        EndOfBuffer                   = { link = "NonText" },

        -- Diagnostics (Cloud original style)
        DiagnosticError               = { fg = colors.red },
        DiagnosticWarn                = { fg = colors.orange },
        DiagnosticInfo                = { fg = colors.blue },
        DiagnosticHint                = { fg = colors.navy },
        DiagnosticOk                  = { fg = colors.green },

        DiagnosticSignError           = { link = "CloudRedSign" },
        DiagnosticSignWarn            = { link = "CloudYellowSign" },
        DiagnosticSignInfo            = { link = "CloudBlueSign" },
        DiagnosticSignHint            = { link = "CloudAquaSign" },
        DiagnosticSignOk              = { link = "CloudGreenSign" },

        DiagnosticUnderlineError      = { undercurl = config.undercurl, sp = colors.red },
        DiagnosticUnderlineWarn       = { undercurl = config.undercurl, sp = colors.orange },
        DiagnosticUnderlineInfo       = { undercurl = config.undercurl, sp = colors.blue },
        DiagnosticUnderlineHint       = { undercurl = config.undercurl, sp = colors.navy },
        DiagnosticUnderlineOk         = { undercurl = config.undercurl, sp = colors.green },

        DiagnosticFloatingError       = { fg = colors.red },
        DiagnosticFloatingWarn        = { fg = colors.orange },
        DiagnosticFloatingInfo        = { fg = colors.blue },
        DiagnosticFloatingHint        = { fg = colors.aqua },
        DiagnosticFloatingOk          = { fg = colors.green },

        DiagnosticVirtualTextError    = { fg = colors.red },
        DiagnosticVirtualTextWarn     = { fg = colors.orange },
        DiagnosticVirtualTextInfo     = { fg = colors.blue },
        DiagnosticVirtualTextHint     = { fg = colors.aqua },
        DiagnosticVirtualTextOk       = { fg = colors.green },

        -- LSP base
        LspReferenceText              = { bg = colors.selection },
        LspReferenceRead              = { bg = colors.selection },
        LspReferenceWrite             = { bg = colors.selection },
        LspCodeLens                   = { fg = colors.gray },
        LspSignatureActiveParameter   = { fg = colors.blue, bold = config.bold },

        -- Git
        GitSignsAdd                   = { fg = colors.green },
        GitSignsChange                = { fg = colors.orange },
        GitSignsDelete                = { fg = colors.red },

        -- Telescope
        TelescopeNormal               = { fg = colors.fg1, bg = colors.bg1 },
        TelescopeSelection            = { bg = colors.selection },
        TelescopeSelectionCaret       = { fg = colors.blue },
        TelescopeMultiSelection       = { fg = colors.gray },
        TelescopeBorder               = { fg = colors.bg1, bg = colors.bg1 },
        TelescopePromptBorder         = { fg = colors.bg1, bg = colors.bg1 },
        TelescopeResultsBorder        = { fg = colors.bg1, bg = colors.bg1 },
        TelescopePreviewBorder        = { fg = colors.bg1, bg = colors.bg1 },
        TelescopeMatching             = { fg = colors.blue, bold = config.bold },
        TelescopePromptPrefix         = { fg = colors.blue },
        TelescopePrompt               = { link = "TelescopeNormal" },

        -- nvim-cmp
        CmpItemAbbr                   = { fg = colors.fg0 },
        CmpItemAbbrDeprecated         = { fg = colors.gray },
        CmpItemAbbrMatch              = { fg = colors.blue, bold = config.bold },
        CmpItemAbbrMatchFuzzy         = { fg = colors.blue },
        CmpItemMenu                   = { fg = colors.gray },

        CmpItemKindText               = { fg = colors.orange },
        CmpItemKindVariable           = { fg = colors.orange },
        CmpItemKindMethod             = { fg = colors.blue },
        CmpItemKindFunction           = { fg = colors.blue },
        CmpItemKindConstructor        = { fg = colors.yellow },
        CmpItemKindUnit               = { fg = colors.blue },
        CmpItemKindField              = { fg = colors.blue },
        CmpItemKindClass              = { fg = colors.yellow },
        CmpItemKindInterface          = { fg = colors.yellow },
        CmpItemKindModule             = { fg = colors.blue },
        CmpItemKindProperty           = { fg = colors.blue },
        CmpItemKindValue              = { fg = colors.orange },
        CmpItemKindEnum               = { fg = colors.yellow },
        CmpItemKindOperator           = { fg = colors.yellow },
        CmpItemKindKeyword            = { fg = colors.purple },
        CmpItemKindEvent              = { fg = colors.purple },
        CmpItemKindReference          = { fg = colors.purple },
        CmpItemKindColor              = { fg = colors.purple },
        CmpItemKindSnippet            = { fg = colors.green },
        CmpItemKindFile               = { fg = colors.blue },
        CmpItemKindFolder             = { fg = colors.blue },
        CmpItemKindEnumMember         = { fg = colors.aqua },
        CmpItemKindConstant           = { fg = colors.orange },
        CmpItemKindStruct             = { fg = colors.yellow },
        CmpItemKindTypeParameter      = { fg = colors.yellow },

        -- Blink (optional, same semantics as cmp)
        BlinkCmpLabel                 = { link = "CmpItemAbbr" },
        BlinkCmpLabelDeprecated       = { link = "CmpItemAbbrDeprecated" },
        BlinkCmpLabelMatch            = { link = "CmpItemAbbrMatch" },
        BlinkCmpLabelDetail           = { fg = colors.gray },
        BlinkCmpLabelDescription      = { fg = colors.gray },
        BlinkCmpKindText              = { link = "CmpItemKindText" },
        BlinkCmpKindVariable          = { link = "CmpItemKindVariable" },
        BlinkCmpKindMethod            = { link = "CmpItemKindMethod" },
        BlinkCmpKindFunction          = { link = "CmpItemKindFunction" },
        BlinkCmpKindConstructor       = { link = "CmpItemKindConstructor" },
        BlinkCmpKindUnit              = { link = "CmpItemKindUnit" },
        BlinkCmpKindField             = { link = "CmpItemKindField" },
        BlinkCmpKindClass             = { link = "CmpItemKindClass" },
        BlinkCmpKindInterface         = { link = "CmpItemKindInterface" },
        BlinkCmpKindModule            = { link = "CmpItemKindModule" },
        BlinkCmpKindProperty          = { link = "CmpItemKindProperty" },
        BlinkCmpKindValue             = { link = "CmpItemKindValue" },
        BlinkCmpKindEnum              = { link = "CmpItemKindEnum" },
        BlinkCmpKindOperator          = { link = "CmpItemKindOperator" },
        BlinkCmpKindKeyword           = { link = "CmpItemKindKeyword" },
        BlinkCmpKindEvent             = { link = "CmpItemKindEvent" },
        BlinkCmpKindReference         = { link = "CmpItemKindReference" },
        BlinkCmpKindColor             = { link = "CmpItemKindColor" },
        BlinkCmpKindSnippet           = { link = "CmpItemKindSnippet" },
        BlinkCmpKindFile              = { link = "CmpItemKindFile" },
        BlinkCmpKindFolder            = { link = "CmpItemKindFolder" },
        BlinkCmpKindEnumMember        = { link = "CmpItemKindEnumMember" },
        BlinkCmpKindConstant          = { link = "CmpItemKindConstant" },
        BlinkCmpKindStruct            = { link = "CmpItemKindStruct" },
        BlinkCmpKindTypeParameter     = { link = "CmpItemKindTypeParameter" },
        BlinkCmpSource                = { fg = colors.gray },
        BlinkCmpGhostText             = { fg = colors.bg4 },

        NavicIconsFile                = { link = "CloudBlue" },
        NavicIconsModule              = { link = "CloudOrange" },
        NavicIconsNamespace           = { link = "CloudBlue" },
        NavicIconsPackage             = { link = "CloudAqua" },
        NavicIconsClass               = { link = "CloudYellow" },
        NavicIconsMethod              = { link = "CloudBlue" },
        NavicIconsProperty            = { link = "CloudAqua" },
        NavicIconsField               = { link = "CloudPurple" },
        NavicIconsConstructor         = { link = "CloudBlue" },
        NavicIconsEnum                = { link = "CloudPurple" },
        NavicIconsInterface           = { link = "CloudGreen" },
        NavicIconsFunction            = { link = "CloudBlue" },
        NavicIconsVariable            = { link = "CloudPurple" },
        NavicIconsConstant            = { link = "CloudOrange" },
        NavicIconsString              = { link = "CloudGreen" },
        NavicIconsNumber              = { link = "CloudOrange" },
        NavicIconsBoolean             = { link = "CloudOrange" },
        NavicIconsArray               = { link = "CloudOrange" },
        NavicIconsObject              = { link = "CloudOrange" },
        NavicIconsKey                 = { link = "CloudAqua" },
        NavicIconsNull                = { link = "CloudOrange" },
        NavicIconsEnumMember          = { link = "CloudYellow" },
        NavicIconsStruct              = { link = "CloudPurple" },
        NavicIconsEvent               = { link = "CloudYellow" },
        NavicIconsOperator            = { link = "CloudRed" },
        NavicIconsTypeParameter       = { link = "CloudRed" },

        -- Text and separators (previously GruvboxWhite)
        NavicText                     = { link = "CloudWhite" },
        NavicSeparator                = { link = "CloudWhite" },

        MiniAnimateCursor             = { reverse = true, nocombine = true },
        MiniAnimateNormalFloat        = { fg = colors.fg1, bg = colors.bg1 },

        MiniCursorword                = { underline = true },
        MiniCursorwordCurrent         = { underline = true },

        MiniHipatternsFixme           = { fg = colors.bg0, bg = colors.red, bold = config.bold },
        MiniHipatternsHack            = { fg = colors.bg0, bg = colors.yellow, bold = config.bold },
        MiniHipatternsNote            = { fg = colors.bg0, bg = colors.blue, bold = config.bold },
        MiniHipatternsTodo            = { fg = colors.bg0, bg = colors.aqua, bold = config.bold },

        miniTrailspace                = { bg = colors.red },

        ["@comment"]                  = { link = "Comment" },
        ["@none"]                     = { bg = "NONE", fg = "NONE" },
        ["@preproc"]                  = { link = "PreProc" },
        ["@define"]                   = { link = "Define" },
        ["@operator"]                 = { link = "Operator" },

        ["@punctuation"]              = { link = "Delimiter" },
        ["@punctuation.delimiter"]    = { link = "Delimiter" },
        ["@punctuation.bracket"]      = { link = "Delimiter" },
        ["@punctuation.special"]      = { link = "Delimiter" },

        ["@string"]                   = { link = "String" },
        ["@string.regex"]             = { link = "String" },
        ["@string.regexp"]            = { link = "String" },
        ["@string.escape"]            = { link = "SpecialChar" },
        ["@string.special"]           = { link = "SpecialChar" },
        ["@string.special.path"]      = { link = "Underlined" },
        ["@string.special.symbol"]    = { link = "Identifier" },
        ["@string.special.url"]       = { link = "Underlined" },

        ["@character"]                = { link = "Character" },
        ["@character.special"]        = { link = "SpecialChar" },

        ["@boolean"]                  = { link = "Boolean" },
        ["@number"]                   = { link = "Number" },
        ["@number.float"]             = { link = "Float" },
        ["@float"]                    = { link = "Float" },

        ["@function"]                 = { link = "Function" },
        ["@function.builtin"]         = { link = "Special" },
        ["@function.call"]            = { link = "Function" },
        ["@function.macro"]           = { link = "Macro" },
        ["@function.method"]          = { link = "Function" },
        ["@method"]                   = { link = "Function" },
        ["@method.call"]              = { link = "Function" },
        ["@constructor"]              = { link = "Special" },

        ["@parameter"]                = { link = "Identifier" },

        ["@keyword"]                  = { link = "Keyword" },
        ["@keyword.conditional"]      = { link = "Conditional" },
        ["@keyword.debug"]            = { link = "Debug" },
        ["@keyword.directive"]        = { link = "PreProc" },
        ["@keyword.directive.define"] = { link = "Define" },
        ["@keyword.exception"]        = { link = "Exception" },
        ["@keyword.function"]         = { link = "Keyword" },
        ["@keyword.import"]           = { link = "Include" },
        ["@keyword.operator"]         = { fg = colors.navy },
        ["@keyword.repeat"]           = { link = "Repeat" },
        ["@keyword.return"]           = { link = "Keyword" },
        ["@keyword.storage"]          = { link = "StorageClass" },

        ["@conditional"]              = { link = "Conditional" },
        ["@repeat"]                   = { link = "Repeat" },
        ["@debug"]                    = { link = "Debug" },
        ["@label"]                    = { link = "Label" },
        ["@include"]                  = { link = "Include" },
        ["@exception"]                = { link = "Exception" },

        ["@type"]                     = { link = "Type" },
        ["@type.builtin"]             = { link = "Type" },
        ["@type.definition"]          = { link = "Typedef" },
        ["@type.qualifier"]           = { link = "Type" },
        ["@storageclass"]             = { link = "StorageClass" },
        ["@attribute"]                = { link = "PreProc" },

        ["@field"]                    = { link = "Identifier" },
        ["@property"]                 = { link = "Identifier" },

        ["@variable"]                 = { fg = colors.fg1 },
        ["@variable.builtin"]         = { link = "Special" },
        ["@variable.member"]          = { link = "Identifier" },
        ["@variable.parameter"]       = { link = "Identifier" },

        ["@constant"]                 = { link = "Constant" },
        ["@constant.builtin"]         = { link = "Special" },
        ["@constant.macro"]           = { link = "Define" },

        ["@markup"]                   = { fg = colors.fg1 },
        ["@markup.strong"]            = { bold = config.bold },
        ["@markup.italic"]            = { italic = config.italic.emphasis },
        ["@markup.underline"]         = { underline = config.underline },
        ["@markup.strikethrough"]     = { strikethrough = config.strikethrough },
        ["@markup.heading"]           = { link = "Title" },
        ["@markup.raw"]               = { link = "String" },
        ["@markup.math"]              = { link = "Special" },
        ["@markup.environment"]       = { link = "Macro" },
        ["@markup.environment.name"]  = { link = "Type" },
        ["@markup.link"]              = { link = "Underlined" },
        ["@markup.link.label"]        = { link = "SpecialChar" },
        ["@markup.list"]              = { link = "Delimiter" },
        ["@markup.list.checked"]      = { fg = colors.green },
        ["@markup.list.unchecked"]    = { fg = colors.gray },

        ["@comment.todo"]             = { link = "Todo" },
        ["@comment.note"]             = { link = "SpecialComment" },
        ["@comment.warning"]          = { link = "WarningMsg" },
        ["@comment.error"]            = { link = "ErrorMsg" },

        ["@diff.plus"]                = { link = "DiffAdd" },
        ["@diff.minus"]               = { link = "DiffDelete" },
        ["@diff.delta"]               = { link = "DiffChange" },

        ["@module"]                   = { fg = colors.fg1 },
        ["@namespace"]                = { fg = colors.fg1 },
        ["@symbol"]                   = { link = "Identifier" },

        -- LSP semantic tokens mapped onto TS groups
        ["@lsp.type.class"]           = { link = "@type" },
        ["@lsp.type.comment"]         = { link = "@comment" },
        ["@lsp.type.decorator"]       = { link = "@macro" },
        ["@lsp.type.enum"]            = { link = "@type" },
        ["@lsp.type.enumMember"]      = { link = "@constant" },
        ["@lsp.type.function"]        = { link = "@function" },
        ["@lsp.type.interface"]       = { link = "@constructor" },
        ["@lsp.type.macro"]           = { link = "@macro" },
        ["@lsp.type.method"]          = { link = "@method" },
        ["@lsp.type.namespace"]       = { link = "@namespace" },
        ["@lsp.type.parameter"]       = { link = "@parameter" },
        ["@lsp.type.property"]        = { link = "@property" },
        ["@lsp.type.struct"]          = { link = "@type" },
        ["@lsp.type.type"]            = { link = "@type" },
        ["@lsp.type.typeParameter"]   = { link = "@type.definition" },
        ["@lsp.type.variable"]        = { link = "@variable" },
    }

    -- user overrides (config.overrides)
    for group, hl in pairs(config.overrides) do
        if groups[group] then
            groups[group].link = nil -- avoid mixing links with other attrs
        end
        groups[group] = vim.tbl_extend("force", groups[group] or {}, hl)
    end

    return groups
end

---@param config CloudConfig?
function Cloud.setup(config)
    Cloud.config = vim.deepcopy(default_config)
    Cloud.config = vim.tbl_deep_extend("force", Cloud.config, config or {})
end

--- main load function
function Cloud.load()
    if vim.version().minor < 8 then
        vim.notify_once("cloud.nvim: you must use neovim 0.8 or higher")
        return
    end

    -- reset colors
    if vim.g.colors_name then
        vim.cmd.hi("clear")
    end

    vim.g.colors_name = "cloud"
    vim.o.termguicolors = true
    vim.o.background = "light"

    local groups = get_groups()

    for group, settings in pairs(groups) do
        vim.api.nvim_set_hl(0, group, settings)
    end
end

return Cloud
