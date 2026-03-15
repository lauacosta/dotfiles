local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local f  = ls.function_node

return {
    s("entry", {
        f(function()
            return "# " .. os.date("%d/%m/%Y")
        end),
        t({ "", "", "## TODO", "", "## DONE" }),
    }),
}
