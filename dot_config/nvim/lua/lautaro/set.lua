vim.g.mapleader = " "
vim.g.maplocalleader = " "
local set = vim.opt

set.clipboard = "unnamedplus"
set.cursorline = true
set.linebreak = false
set.expandtab = true
set.mouse = "a"
set.number = true
set.relativenumber = true
set.scrolloff = 4
set.shiftround = true
set.shiftwidth = 4
set.showmode = false
set.smartcase = true
set.smartindent = true
set.spelllang = { "en", "es" }
set.tabstop = 4
set.termguicolors = true
set.wrap = false
vim.o.completeopt = vim.o.completeopt:gsub(",?preview", "")

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.md", "*.txt", "*.tex" },
	command = "set linebreak | set wrap",
	vim.keymap.set("n", "<A-n>", "]sz=", { noremap = true }),
	vim.keymap.set("n", "<A-p>", "[sz=", { noremap = true }),
})
