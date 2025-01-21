return {
	{
		"nvim-treesitter/nvim-treesitter",
		enabled = true,
		event = "VeryLazy",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "query", "sql" },
				sync_install = false,
				auto_install = true,
				indent = {
					enable = true,
				},
				highlight = {
					enable = true,
					disable = { "latex", "csv" },
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		enabled = true,
		opts = true,
	},
}
