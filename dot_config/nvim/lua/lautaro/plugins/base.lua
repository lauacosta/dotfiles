return {
    {
        dir = vim.fn.stdpath("config"),
        name = "colors",
        lazy = false,
        priority = 1000,
        config = function()
            -- Remember that current is just 'gruvbox' or 'cloud' depending on the darkman setting
            require("current").load()
        end,
    },
    {
        "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
        -- your configuration comes here; leave empty for default settings
    },
    },

    {
        'SmiteshP/nvim-navic',
        dependencies = "neovim/nvim-lspconfig",
        opts = {
            highlight = true,
            custom_hl = true,
            separator = " › ",
        },
    },
    {
        'dmtrKovalenko/fff.nvim',
        build = function()
            require("fff.download").download_or_build_binary()
        end,
        opts = {
            debug = {
                enabled = true,
                show_scores = true,
            },
        },
        lazy = false,
        keys = {
            {
                "<space>ff",
                function() require('fff').find_files() end,
                desc = 'FFFind files',
            },
            {
                "<space>sn",
                function() require('fff').find_files_in_dir(vim.fn.stdpath("config")) end,
                desc = "Find files in config dir",
            },
            {
                "<space>g",
                function() require('fff').find_in_git_root() end,
                desc = "Find in git root",
            }

        }
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
