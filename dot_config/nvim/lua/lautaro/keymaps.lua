vim.keymap.set("n", "YY", "va{Vy", { silent = true, noremap = true })

vim.keymap.set("n", "<up>", "<C-w><up>", { silent = true, noremap = true })
vim.keymap.set("n", "<down>", "<C-w><down>", { silent = true, noremap = true })
vim.keymap.set("n", "<left>", "<C-w><left>", { silent = true, noremap = true })
vim.keymap.set("n", "<right>", "<C-w><right>", { silent = true, noremap = true })
vim.keymap.set("n", "<right>", "<C-w><right>", { silent = true, noremap = true })

vim.keymap.set("n", "<A-k>", ":m-2<CR>==", { noremap = true })
vim.keymap.set("n", "<A-j>", ":m+1<CR>==", { noremap = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true })

vim.keymap.set("n", "<F11>", ":set spell!<CR>", { noremap = true })
vim.keymap.set("n", "<F8>", ":lua vim.lsp.inlay_hint.enable(0, true)<CR>", { noremap = true })
vim.keymap.set("n", "<F9>", ":lua vim.lsp.inlay_hint.enable(0, false)<CR>", { noremap = true })

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
