local map = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = desc, silent = true, noremap = true })
end

map("YY", "va{Vy", "Yanks el contenido entre dos llaves")
map("<up>", "<C-w><up>", "Move to the tab above")
map("<down>", "<C-w><down>", "Move to the tab below")
map("<left>", "<C-w><left>", "Move to the left tab")
map("<right>", "<C-w><right>", "Move to the right tab")
map("<A-k>", ":m-2<CR>==", "Move the line above")
map("<A-j>", ":m+1<CR>==", "Move the line below")
-- map("<F11>", ":set spell!<CR>", "Toggle spell parsing")
map("<F8>", ":lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>", "Enable inlay hints")
map("<leader>pv", vim.cmd.Ex, "Open the current folder")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, desc = "Virtual: Move the line above" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, desc = "Virtual: Move the line below" })

local job_id = 0
vim.keymap.set("n", "<space>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 10)

  job_id = vim.bo.channel
end)

vim.keymap.set("n", "<space>cc", function()
  vim.fn.chansend(job_id, { "clear\r\n just run\r\n" })
end)

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Resalto el area que copio",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  desc = "Pequeños mensajes :)",
  group = vim.api.nvim_create_augroup("messages:)", { clear = true }),
  pattern = { "*.c", "*.h", "*.rs", "*.ml" },
  command = "echo 'oh shit, here we go again'",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.md", "*.txt", "*.tex" },
  command = "set linebreak | set nowrap",
  vim.keymap.set("n", "<A-n>", "]sz=", { noremap = true }),
  vim.keymap.set("n", "<A-p>", "[sz=", { noremap = true }),
})


vim.api.nvim_create_autocmd({ "LspAttach", "InsertLeave", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("LspCodelens", { clear = true }),
  callback = function()
    vim.lsp.codelens.refresh({ bufnr = 0 })
  end,
})
