---@class ink
---@field config inkconfig
local ink = {}

---@class italicconfig
---@field strings boolean
---@field comments boolean
---@field operators boolean
---@field folds boolean
---@field emphasis boolean

---@class highlightdefinition
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

---@class inkconfig
---@field bold boolean?
---@field dim_inactive boolean?
---@field inverse boolean?
---@field invert_selection boolean?
---@field invert_signs boolean?
---@field invert_tabline boolean?
---@field italic italicconfig?
---@field overrides table<string, highlightdefinition>?
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
    inverse = false,
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
}

ink.config = vim.deepcopy(default_config)

--------------------------------------------------------------------------------
-- Palettes
--------------------------------------------------------------------------------

local palettes = {
    light = {
        bg = "#fdfbf5",
        lightbg = "#f7f4ee",
        fg = "#2b2b2b",
        gray = "#7a7a7a",
        midgray = "#5f5f5f",

        navy = "#2b2b2b",
        blue = "#2b2b2b",

        func_orange = "#2b2b2b",
        green = "#2b2b2b",
        amber = "#2b2b2b",
        orange = "#2b2b2b",
        red = "#2b2b2b",
        purple = "#2b2b2b",
        teal = "#2b2b2b",

        accent = "#2b2b2b",

        selection = "#e8e3d8",
        selection_text = "#2b2b2b",
    },

    dark = {
        bg = "#181818",
        fg = "#ebdbb2",
        lightbg = "#1a1a1a",
        -- fg = "#e4e4e4",
        gray = "#7a7a7a",
        midgray = "#aaaaaa",

        navy = "#e4e4e4",
        blue = "#e4e4e4",

        func_orange = "#e4e4e4",
        green = "#e4e4e4",
        amber = "#e4e4e4",
        orange = "#e4e4e4",
        red = "#e4e4e4",
        purple = "#e4e4e4",
        teal = "#e4e4e4",

        accent = "#e4e4e4",

        selection = "#333333",
        selection_text = "#ffffff",
    },
}

--------------------------------------------------------------------------------
-- Palette selection
--------------------------------------------------------------------------------

local function get_palette()
    if vim.o.background == "dark" then
        return palettes.dark
    else
        return palettes.light
    end
end

--------------------------------------------------------------------------------
-- Semantic colors
--------------------------------------------------------------------------------

local function get_colors()
    local p = vim.deepcopy(get_palette())
    local config = ink.config

    for color, hex in pairs(config.palette_overrides) do
        p[color] = hex
    end

    return {
        bg0 = p.bg,
        bg1 = p.lightbg,
        bg2 = p.lightbg,
        bg3 = p.selection,
        bg4 = p.midgray,

        fg0 = p.fg,
        fg1 = p.fg,
        fg2 = p.midgray,
        fg3 = p.gray,
        fg4 = p.gray,

        red = p.red,
        green = p.green,
        yellow = p.amber,
        blue = p.blue,
        purple = p.purple,
        aqua = p.teal,
        orange = p.orange,

        neutral_red = p.red,
        neutral_green = p.green,
        neutral_yellow = p.amber,
        neutral_blue = p.blue,
        neutral_purple = p.purple,
        neutral_aqua = p.teal,

        gray = p.gray,

        navy = p.navy,
        accent = p.accent,
        func = p.func_orange,
        selection = p.selection,
        selection_text = p.selection_text,
    }
end

--------------------------------------------------------------------------------
-- Highlight groups
--------------------------------------------------------------------------------

local function get_groups()
    local colors = get_colors()
    local config = ink.config

    if config.terminal_colors then
        local term_colors = {
            colors.bg0,
            colors.fg1,
            colors.fg1,
            colors.fg1,
            colors.fg1,
            colors.fg1,
            colors.fg1,
            colors.fg4,
            colors.gray,
            colors.fg1,
            colors.fg1,
            colors.fg1,
            colors.fg1,
            colors.fg1,
            colors.fg1,
            colors.fg1,
        }

        for i, v in ipairs(term_colors) do
            vim.g["terminal_color_" .. (i - 1)] = v
        end
    end

    local groups = {

        normal = { fg = colors.fg1, bg = colors.bg0 },
        normalfloat = { fg = colors.fg1, bg = colors.bg1 },

        cursorline = { bg = colors.bg1 },
        cursorcolumn = { link = "cursorline" },
        colorcolumn = { bg = colors.bg1 },

        visual = { bg = colors.selection },

        linenr = { fg = colors.gray },
        cursorlinenr = { fg = colors.midgray },

        signcolumn = { bg = colors.bg0 },

        statusline = { fg = colors.gray, bg = colors.bg1 },
        statuslinenc = { fg = colors.gray, bg = colors.bg1 },

        tablinefill = { bg = colors.bg1 },
        tablinesel = { fg = colors.fg1, bg = colors.bg1, bold = true },

        comment = { fg = colors.gray, italic = config.italic.comments },
        todo = { fg = colors.fg1, bold = true },
        done = { fg = colors.gray },

        keyword = { fg = colors.fg1, bold = config.bold },
        conditional = { link = "keyword" },

        operator = { fg = colors.midgray },

        identifier = { fg = colors.fg1 },
        ["function"] = { fg = colors.fg1, bold = config.bold },

        string = { fg = colors.fg1, italic = config.italic.strings },
        character = { fg = colors.fg1 },

        boolean = { fg = colors.fg1 },
        number = { fg = colors.fg1 },
        float = { fg = colors.fg1 },

        type = { fg = colors.midgray, bold = config.bold },

        constant = { fg = colors.fg1 },

        delimiter = { fg = colors.fg1 },

        matchparen = { bold = true },

        diagnosticerror = { fg = colors.fg1, underline = true },
        diagnosticwarn = { fg = colors.fg1, italic = true },
        diagnosticinfo = { fg = colors.gray },
        diagnostichint = { fg = colors.gray },

        diffadd = { fg = colors.fg1 },
        diffdelete = { fg = colors.gray },
        diffchange = { fg = colors.midgray },

        pmenu = { fg = colors.fg1, bg = colors.bg1 },
        pmenusel = { fg = colors.bg0, bg = colors.midgray, bold = true },

        whitespace = { fg = colors.bg2 },
        endofbuffer = { fg = colors.bg1 },

        ["@comment"] = { link = "comment" },
        ["@keyword"] = { link = "keyword" },
        ["@function"] = { link = "function" },
        ["@string"] = { link = "string" },
        ["@number"] = { link = "number" },
        ["@type"] = { link = "type" },
        ["@variable"] = { fg = colors.fg1 },
        ["@operator"] = { link = "operator" },
        ["@punctuation"] = { link = "delimiter" },
    }

    for group, hl in pairs(config.overrides) do
        groups[group] = vim.tbl_extend("force", groups[group] or {}, hl)
    end

    return groups
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

function ink.setup(config)
    ink.config = vim.deepcopy(default_config)
    ink.config = vim.tbl_deep_extend("force", ink.config, config or {})
end

--------------------------------------------------------------------------------
-- Load colorscheme
--------------------------------------------------------------------------------

function ink.load()
    if vim.g.colors_name then
        vim.cmd.hi("clear")
    end

    vim.g.colors_name = "ink"
    vim.o.termguicolors = true

    local groups = get_groups()

    for group, settings in pairs(groups) do
        vim.api.nvim_set_hl(0, group, settings)
    end
end

return ink
