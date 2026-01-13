return {
    {
        dir = vim.fn.stdpath("config"),
        name = "colors",
        lazy = false,
        priority = 1000,
        config = function()
            require("current").load()
        end,
    },
    {
        'nvim-java/nvim-java',
        config = function()
            require('java').setup({
                lombok = {
                    enable = true,
                    version = '1.18.40',
                },
            })
            vim.lsp.enable('jdtls')
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        config = function()
            local ls = require("luasnip")

            require("luasnip.loaders.from_lua").lazy_load({
                paths = vim.fn.stdpath("config") .. "/lua/snippets"
            })

            -- TAB to expand/jump
            vim.keymap.set({ "i", "s" }, "<Tab>", function()
                if ls.expand_or_jumpable() then
                    return "<Plug>luasnip-expand-or-jump"
                else
                    return "<Tab>"
                end
            end, { expr = true })

            vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
                if ls.jumpable(-1) then
                    return "<Plug>luasnip-jump-prev"
                else
                    return "<S-Tab>"
                end
            end, { expr = true })
        end
    },

    { "tpope/vim-fugitive",          enabled = true, event = "VeryLazy" },
    { "f-person/git-blame.nvim",     enabled = true, event = "VeryLazy" },
    { "tpope/vim-commentary",        enabled = true, event = "VeryLazy" },
    { "nvim-tree/nvim-web-devicons", enabled = true, event = "VeryLazy" },
    {
        "lewis6991/gitsigns.nvim",
        enabled = true,
        event = "VeryLazy",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },
    {
        "folke/todo-comments.nvim",
        enabled = true,
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    {
        "echasnovski/mini.nvim",
        enabled = true,
        event = "VeryLazy",
        config = function()
            local statusline = require("mini.statusline")
            statusline.setup({ use_icons = true })

            local miniclue = require("mini.clue")
            miniclue.setup({
                triggers = {
                    { mode = 'n', keys = '<Leader>' },
                    { mode = 'n', keys = 'g' },
                    { mode = 'n', keys = '<C-w>' },
                    { mode = 'i', keys = '<C-x>' },
                    { mode = 'c', keys = '<C-r>' },
                },
                clues = {
                    { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.windows({ submode_resize = true }),
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.registers(),
                },

                window = {
                    delay = 100,
                    config = {
                        width = 'auto',
                        border = 'double',
                    }
                }
            })
        end,
    },
}
