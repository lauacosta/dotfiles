return {
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
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
			{ "nvim-tree/nvim-web-devicons" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "bottom_pane",
					-- layout_config = {
					-- height = 0.25
					-- }
				},
				extension = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { desc = "Telescope: " .. desc })
			end
			map("<leader><leader>", builtin.buffers, "[ ] Find existing buffers")
			map("<leader>s.", builtin.oldfiles, '[S]earch Recent Files ("." for repeat)')
			map("<leader>sf", builtin.find_files, "[S]earch [F]iles")
			map("<leader>sd", builtin.diagnostics, "[S]earch [D]iagnostics")
			map("<leader>sg", builtin.git_files, "[S]earch [G]itfiles")
			map("<leader>sk", builtin.keymaps, "[S]earch [K]eymaps")
			map("<leader>sw", builtin.grep_string, "[S]earch current [W]ord")
			map("<C-g>", function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end, "[G]rep string")
			map("<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, "[S]earch [N]eovim files")
		end,
	},
}
