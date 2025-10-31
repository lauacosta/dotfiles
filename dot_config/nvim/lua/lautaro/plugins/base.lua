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
            -- this will download prebuild binary or try to use existing rustup toolchain to build from source
            -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
            require("fff.download").download_or_build_binary()
        end,
        -- if you are using nixos
        -- build = "nix run .#release",
        opts = {                    -- (optional)
            debug = {
                enabled = true,     -- we expect your collaboration at least during the beta
                show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
            },
        },
        -- No need to lazy-load with lazy.nvim.
        -- This plugin initializes itself lazily.
        lazy = false,
        keys = {
            {
                "ff", -- try it if you didn't it is a banger keybinding for a picker
                function() require('fff').find_files() end,
                desc = 'FFFind files',
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
