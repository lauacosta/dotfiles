return {
    {
        "nvim-telescope/telescope.nvim",
        enabled = true,
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
        },
        config = function()
            require("telescope").setup({
                pickers = {
                    find_files = {
                        theme = "ivy",
                    },

                    help_tags = {
                        theme = "ivy",
                    },

                    lsp_diagnostics = {
                        theme = "ivy",
                    },

                    git_files = {
                        theme = "ivy",
                    },

                    lsp_references = {
                        theme = "ivy",
                    },
                },
                extensions = {
                    fzf = {},
                },
            })

            require("telescope").load_extension("fzf")

            local builtin = require("telescope.builtin")
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { desc = "Telescope: " .. desc })
            end
            map("<leader>bb", builtin.buffers, "[ ] Find existing buffers")
            map("<leader>s.", builtin.oldfiles, '[S]earch Recent Files ("." for repeat)')
            map("<leader>sp", function()
                builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
            end, "[S]earch [P]ackages")
            map("<leader>d", builtin.diagnostics, "[S]earch [D]iagnostics")
            map("<leader>sk", builtin.keymaps, "[S]earch [K]eymaps")
            map("<leader>sr", builtin.lsp_references, "[S]earch [R]eferences")
            map("<leader>sw", builtin.grep_string, "[S]earch current [W]ord")
            map("<leader>sh", builtin.help_tags, "[S]earch [H]elp")
            -- map("<C-g>", function()
            --     builtin.grep_string({ search = vim.fn.input("Grep > ") })
            -- end, "[G]rep string")

            require("lautaro.telescope.multigrep").setup()
        end,
    },
}
