return {
	{ "tpope/vim-fugitive", enabled = true, event = "VeryLazy" },
	{ "f-person/git-blame.nvim", enabled = true, event = "VeryLazy" },
	{ "windwp/nvim-ts-autotag", enabled = true },
	{ "tpope/vim-commentary", enabled = true, event = "VeryLazy" },
	-- { "mfussenegger/nvim-jdtls", enabled = true, event = "VeryLazy" },
	{ "nvim-tree/nvim-web-devicons", enabled = true, event = "VeryLazy" },
	{ "kshenoy/vim-signature" },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},
	{ "arturgoms/moonbow.nvim" },
	{
		"Shatur/neovim-ayu",
	},
	{
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({
				compile = false,
				undercurl = true,
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = false,
				dimInactive = false,
				terminalColors = true,
				colors = {
					palette = {},
					theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
				},
				overrides = function(colors)
					return {}
				end,
				theme = "wave",
				background = {
					dark = "wave",
					light = "lotus",
				},
			})

			-- vim.cmd("colorscheme kanagawa")
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		enabled = true,
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				terminal_colors = true,
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = false,
					emphasis = false,
					comments = true,
					operators = false,
					folds = false,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true,
				contrast = "hard",
				overrides = {
					Comment = { fg = "#fe8019" },
					LspInlayHint = { fg = "#928374", italic = true },
					FidgetTitle = { fg = "#fabd2f", bold = true },
					FidgetTask = { fg = "#b8bb26" },
				},
				dim_inactive = false,
				transparent_mode = false,
			})
			vim.cmd.colorscheme("gruvbox")
		end,
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
