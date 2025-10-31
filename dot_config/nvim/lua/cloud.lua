---@class Cloud
---@field config CloudConfig
---@field palette CloudPalette
local Cloud = {}

---@class CloudConfig
---@field bold boolean?
---@field italic boolean?
---@field underline boolean?
---@field undercurl boolean?
---@field transparent_mode boolean?
---@field overrides table<string, table<string, any>>?

local default_config = {
    bold = true,
    italic = true,
    underline = true,
    undercurl = true,
    transparent_mode = false,
    overrides = {},
}

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

local palette = {
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

---Get Cloud palette
---@return CloudPalette
function Cloud.get_palette()
    return palette
end

---Setup user configuration
---@param opts CloudConfig?
function Cloud.setup(opts)
    Cloud.config = vim.tbl_deep_extend("force", default_config, opts or {})
end

---Apply highlights
function Cloud.load()
    vim.o.background = "light"
    local c = Cloud.get_palette()
    local conf = Cloud.config or default_config

    local function set_hl(group, opts)
        local hl = vim.tbl_extend("force", opts, conf.overrides[group] or {})
        vim.api.nvim_set_hl(0, group, hl)
    end

    -- Base editor colors
    set_hl("Normal", { fg = c.fg, bg = conf.transparent_mode and "NONE" or c.bg })
    set_hl("NormalNC", { fg = c.fg, bg = conf.transparent_mode and "NONE" or c.bg })
    set_hl("Cursor", { fg = c.bg, bg = c.navy })
    set_hl("Visual", { bg = c.selection })
    set_hl("VisualNOS", { bg = c.selection })
    set_hl("LineNr", { fg = c.midgray })
    set_hl("CursorLineNr", { fg = c.amber, bold = true })
    set_hl("CursorLine", { bg = c.lightbg })
    set_hl("SignColumn", { bg = c.bg })
    set_hl("ColorColumn", { bg = c.lightbg })
    set_hl("VertSplit", { fg = c.lightbg })
    set_hl("StatusLine", { fg = c.fg, bg = c.lightbg })
    set_hl("StatusLineNC", { fg = c.gray, bg = c.lightbg })
    set_hl("Pmenu", { fg = c.fg, bg = c.lightbg })
    set_hl("PmenuSel", { fg = c.bg, bg = c.blue })
    set_hl("Search", { fg = c.selection_text, bg = c.selection })
    set_hl("IncSearch", { fg = c.selection_text, bg = c.selection })
    set_hl("MatchParen", { fg = c.red, bold = true })

    -- Syntax
    set_hl("Comment", { fg = c.gray, italic = true })
    set_hl("Constant", { fg = c.amber })
    set_hl("String", { fg = c.green })
    set_hl("Character", { fg = c.midgray })
    set_hl("Number", { fg = c.amber })
    set_hl("Boolean", { fg = c.teal })
    set_hl("Float", { fg = c.amber })
    set_hl("Identifier", { fg = c.fg })
    set_hl("Function", { fg = c.func_orange, bold = true })
    set_hl("Statement", { fg = c.navy, bold = true })
    set_hl("Conditional", { fg = c.navy })
    set_hl("Repeat", { fg = c.navy })
    set_hl("Label", { fg = c.navy })
    set_hl("Operator", { fg = c.gray })
    set_hl("Keyword", { fg = c.navy, bold = true })
    set_hl("Exception", { fg = c.red })
    set_hl("PreProc", { fg = c.blue })
    set_hl("Include", { fg = c.navy, bold = true })
    set_hl("Define", { fg = c.navy })
    set_hl("Macro", { fg = c.blue })
    set_hl("Type", { fg = c.navy, bold = true })
    set_hl("StorageClass", { fg = c.blue })
    set_hl("Structure", { fg = c.blue })
    set_hl("Typedef", { fg = c.navy })
    set_hl("Special", { fg = c.teal })
    set_hl("SpecialChar", { fg = c.midgray })
    set_hl("Tag", { fg = c.blue })
    set_hl("Delimiter", { fg = c.fg })
    set_hl("SpecialComment", { fg = c.gray, italic = true })
    set_hl("Underlined", { fg = c.blue, underline = true })
    set_hl("Bold", { bold = true })
    set_hl("Italic", { italic = true })
    set_hl("Error", { fg = c.red })
    set_hl("Todo", { fg = c.purple, bold = true })

    -- Treesitter
    set_hl("@annotation", { fg = c.accent })
    set_hl("@attribute", { fg = c.sky or c.blue, italic = true })
    set_hl("@comment", { fg = c.gray, italic = true })
    set_hl("@constant", { fg = c.amber })
    set_hl("@constant.builtin", { fg = c.teal })
    set_hl("@constant.macro", { fg = c.blue })
    set_hl("@constructor", { fg = c.blue })
    set_hl("@error", { fg = c.red })
    set_hl("@function", { fg = c.func_orange, bold = true })
    set_hl("@function.call", { fg = c.func_orange, bold = true })
    set_hl("@function.method", { fg = c.func_orange, italic = true })
    set_hl("@function.builtin", { fg = c.teal })
    set_hl("@keyword", { fg = c.navy, bold = true })
    set_hl("@keyword.import", { fg = c.navy, bold = true })
    set_hl("@label", { fg = c.navy })
    set_hl("@namespace", { fg = c.fg })
    set_hl("@operator", { fg = c.gray })
    set_hl("@punctuation", { fg = c.fg, bold = true })
    set_hl("@string", { fg = c.green })
    set_hl("@string.regex", { fg = c.blue })
    set_hl("@string.special", { fg = c.midgray })
    set_hl("@tag", { fg = c.blue })
    set_hl("@type", { fg = c.navy, bold = true })
    set_hl("@type.enum.variant", { fg = c.blue, bold = true })
    set_hl("@variable", { fg = c.fg })
    set_hl("@variable.builtin", { fg = c.teal, italic = true })
    set_hl("@variable.member", { fg = c.blue })
    set_hl("@variable.parameter", { fg = c.blue, italic = true })

    -- Diagnostics
    set_hl("DiagnosticError", { fg = c.red, undercurl = true, sp = c.red })
    set_hl("DiagnosticWarn", { fg = c.orange, undercurl = true, sp = c.orange })
    set_hl("DiagnosticInfo", { fg = c.blue, undercurl = true, sp = c.blue })
    set_hl("DiagnosticHint", { fg = c.navy, undercurl = true, sp = c.navy })
    set_hl("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
    set_hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.orange })
    set_hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.blue })
    set_hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.navy })

    -- Diff
    set_hl("DiffAdd", { fg = c.green })
    set_hl("DiffChange", { fg = c.orange })
    set_hl("DiffDelete", { fg = c.red })
    set_hl("DiffText", { fg = c.orange })

    -- LSP
    set_hl("LspReferenceText", { bg = c.selection })
    set_hl("LspReferenceRead", { bg = c.selection })
    set_hl("LspReferenceWrite", { bg = c.selection })
    set_hl("LspSignatureActiveParameter", { fg = c.blue, bold = true })

    -- Completion (nvim-cmp)
    set_hl("CmpItemAbbr", { fg = c.fg })
    set_hl("CmpItemAbbrMatch", { fg = c.blue, bold = true })
    set_hl("CmpItemAbbrMatchFuzzy", { fg = c.blue })
    set_hl("CmpItemKind", { fg = c.teal })
    set_hl("CmpItemMenu", { fg = c.gray })

    -- Telescope
    set_hl("TelescopeBorder", { fg = c.lightbg })
    set_hl("TelescopePromptBorder", { fg = c.lightbg })
    set_hl("TelescopeResultsBorder", { fg = c.lightbg })
    set_hl("TelescopePreviewBorder", { fg = c.lightbg })
    set_hl("TelescopeSelection", { bg = c.selection })
    set_hl("TelescopeMatching", { fg = c.blue, bold = true })

    -- Git
    set_hl("GitSignsAdd", { fg = c.green })
    set_hl("GitSignsChange", { fg = c.orange })
    set_hl("GitSignsDelete", { fg = c.red })

    -- UI / Interface
    set_hl("WinSeparator", { fg = c.lightbg })
    set_hl("NormalFloat", { fg = c.fg, bg = c.lightbg })
    set_hl("FloatBorder", { fg = c.lightbg, bg = c.lightbg })
    set_hl("CursorColumn", { bg = c.lightbg })
    set_hl("QuickFixLine", { bg = c.selection })
    set_hl("TabLine", { fg = c.gray, bg = c.lightbg })
    set_hl("TabLineSel", { fg = c.blue, bg = c.bg })
    set_hl("TabLineFill", { bg = c.lightbg })
end

return Cloud
