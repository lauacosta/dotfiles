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
        'dmtrKovalenko/fff.nvim',
        build = function()
            require("fff.download").download_or_build_binary()
        end,
        opts = {                    -- (optional)
            debug = {
                enabled = true,     -- we expect your collaboration at least during the beta
                show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
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
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
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
        end,
    },
}
