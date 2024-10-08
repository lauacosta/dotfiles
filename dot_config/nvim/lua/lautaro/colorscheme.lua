-- if not pcall(require, "colorbuddy") then
-- 	return
-- end
-- vim.opt.termguicolors = true
-- require("colorizer").setup()
-- local colorbuddy = require("colorbuddy")

-- local Color = colorbuddy.Color
-- local c = colorbuddy.colors
-- local Group = colorbuddy.Group
-- local g = colorbuddy.groups
-- local s = colorbuddy.styles

-- local color_options = {
-- 	turquoise = "#698b69",
-- 	brown = "#a3685a",
-- 	violet = "#b294bb",
-- 	purple = "#8e6fbd",
-- 	cyan = "#8abeb7",
-- 	aqua = "#8ec07c",
-- 	pink = "#fef601",
-- 	yellow = "#f8fe7a",
-- 	red = "#DD2D4A",
-- 	blue = "#96bcbb",
-- 	lilac = "#B294BB",
-- 	champagne = "#E5D0C6",
-- 	orange = "#FE5F00",
-- 	green = "#8aaf91",
-- 	duperdark = "#1d2021",
-- 	-- duperdark = "#282828",
-- 	dupergrey = "#B8B8B8",
-- }

-- for color_name, hex_code in pairs(color_options) do
-- 	Color.new(color_name, hex_code)
-- end

-- Group.new("Identifier", c.red:light())
-- Group.new("Number", c.red:light())
-- Group.new("Import", c.blue)
-- Group.new("Constant", c.lilac, nil, s.bold)
-- Group.new("Special", c.champagne)
-- Group.new("String", c.green:light())
-- Group.new("Delimiter", c.champagne)
-- Group.new("Keyword", c.lilac)
-- Group.new("Statement", c.lilac)
-- Group.new("RedKey", c.red:light())
-- Group.new("Function", c.yellow:light())
-- Group.new("Variable", c.white)
-- Group.new("Type", c.red:light())
-- Group.new("Chain", c.yellow:light(), nil, s.bold)

-- Group.new("Normal", c.white, c.duperdark)
-- Group.new("Comment", c.dupergrey)
-- Group.new("LineNr", c.dupergrey)

-- vim.cmd([[
--     hi link @type.builtin.go			Type
--     hi link @variable.parameter.go		Parameter

--     hi link @string.lua				    String
--     hi link @lsp.type.property.lua		Normal

--     hi link @lsp.type.property.rust		Normal

--     hi link @type.rust				    Type
--     hi link @type.builtin.rust			Type


--     hi link @function.rust			    Function
--     hi link @function.macro.rust		Macro
--     hi link @function.call.rust			Chain

--     hi link @constant.rust			    Constant
--     hi link @operator.rust			    Special

--     hi link @variable.rust			    Variable
--     hi link @variable.parameter.rust	Identifier
--     hi link @lsp.type.parameter.rust	Identifier
--     hi link @lsp.type.namespace.rust	Import

--     hi link @keyword.conditional.rust	RedKey
--     hi link @keyword.repeat.rust		RedKey
--     hi link @keyword.import.rust		Import
--     hi link @keyword.operator.rust		Special

--     hi link @module.rust			    Import
--     hi link @comment.rust			    Comment
--     hi link @punctuation.special.rust	Delimiter

--     hi link @variable.parameter.cpp     Identifier
-- ]])
