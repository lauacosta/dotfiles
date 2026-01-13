---@diagnostic disable: undefined-global
local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { desc = desc, silent = true, noremap = true })
end

local function toggle_project_notes()
    local cwd = vim.fn.getcwd()
    local documents = vim.fn.expand("~/Documents")
    local notes_dir = vim.fn.expand("~/Documents/ideas")

    ---------------------------------------------------------------------
    -- 1. OUTSIDE ~/Documents → do nothing
    ---------------------------------------------------------------------
    if not vim.startswith(cwd, documents) then
        return
    end

    ---------------------------------------------------------------------
    -- 2. INSIDE ~/Documents → figure out first-level folder
    ---------------------------------------------------------------------
    -- Remove "~/Documents/" prefix
    local relative = cwd:sub(#documents + 2)

    -- First directory inside Documents
    local project = relative:match("^([^/]+)")

    -- If directly in ~/Documents or invalid folder → do nothing
    if not project or project == "" then
        return
    end

    ---------------------------------------------------------------------
    -- 3. Compute target notes file
    ---------------------------------------------------------------------
    local target = notes_dir .. "/" .. project .. ".md"
    local target_abs = vim.fn.fnamemodify(target, ":p")

    ---------------------------------------------------------------------
    -- 4. Create file safely (never overwrites)
    ---------------------------------------------------------------------
    if vim.loop.fs_stat(target) == nil then
        -- "touch" without truncating
        io.open(target, "a"):close()
    end

    ---------------------------------------------------------------------
    -- 5. Toggle notes file window
    ---------------------------------------------------------------------
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":p")

        if name == target_abs then
            vim.api.nvim_win_close(win, true)
            return
        end
    end

    -- Not open → open it
    vim.cmd("vsplit " .. target)
end

map("%", "ggVG", "Select all text")
map("YY", "va{V", "Selecciona el contenido entre dos llaves")
map("<up>", "<C-w><up>", "Move to the tab above")
map("<down>", "<C-w><down>", "Move to the tab below")
map("<left>", "<C-w><left>", "Move to the left tab")
map("<right>", "<C-w><right>", "Move to the right tab")
map("<A-k>", ":m-2<CR>==", "Move the line above")
map("<A-j>", ":m+1<CR>==", "Move the line below")
map("<F8>", ":lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>", "Enable inlay hints")
map("<leader>pv", vim.cmd.Ex, "Open the current folder")
map("<C-g>", ":Git<CR>", "[G]it fugitive")
map("<C-p>", toggle_project_notes, "[P]roject notes")


map("gd", function()
    vim.lsp.buf.definition()
end, "Goto definition")

map("<leader>gd", function()
    vim.cmd("vsplit")
    vim.lsp.buf.definition()
end, "Goto definition in vsplit")

map("<leader>o", function()
    vim.fn.jobstart({ "gh", "repo", "view", "--web" }, { detach = true })
end, "Open GitHub repo in browser")

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
    pattern = { "*.md", "*.txt", "*.tex" },
    vim.keymap.set("n", "<A-n>", "]sz=", { noremap = true }),
    vim.keymap.set("n", "<A-p>", "[sz=", { noremap = true }),

    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.conceallevel = 2
        vim.opt_local.formatoptions:append("n")
    end,
})

-- vim.api.nvim_create_autocmd({ "LspAttach", "InsertLeave", "BufEnter" }, {
--     group = vim.api.nvim_create_augroup("LspCodelens", { clear = true }),
--     callback = function()
--         vim.lsp.codelens.refresh({ bufnr = 0 })
--     end,
-- })

vim.api.nvim_create_autocmd({ "LspAttach", "InsertLeave", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("LspCodelens", { clear = true }),
    callback = function(args)
        -- Only refresh if buffer has LSP clients with codelens support
        local bufnr = args.buf or 0
        vim.lsp.codelens.refresh({ bufnr = bufnr })
    end,
})
