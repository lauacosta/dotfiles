vim.o.termguicolors = true

-- detect system
if vim.env.COLORFGBG then
    local bg = tonumber(vim.split(vim.env.COLORFGBG, ";")[2])
    vim.o.background = bg and bg < 7 and "dark" or "light"
end

vim.cmd.colorscheme("ink")
require("lautaro")
