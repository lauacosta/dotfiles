local set = vim.opt

vim.g.have_nerd_font = true
set.clipboard = "unnamedplus"
vim.o.splitright = true
set.cursorline = true
vim.opt.signcolumn = "yes:1"
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
vim.g.db_ui_auto_execute_table_helpers = 1

vim.api.nvim_set_hl(0, "@lsp.mod.mutable", { underline = true })
vim.api.nvim_set_hl(0, "@lsp.typemod.variable.consuming.rust", { underline = true, foreground = "#83a598" })
vim.api.nvim_set_hl(0, "@lsp.typemod.keyword.unsafe.rust", { underline = true, bold = true })
vim.api.nvim_set_hl(0, "@lsp.type.module.ocaml", { italic = true, underline = true })
vim.api.nvim_set_hl(0, "@lsp.type.constructor.ocaml", { bold = true })
vim.api.nvim_set_hl(0, "@lsp.type.operator.ocaml", { bold = true })
vim.api.nvim_set_hl(0, "@lsp.typemod.variable.readonly.ocaml", { underline = true })
