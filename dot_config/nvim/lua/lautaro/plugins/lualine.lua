return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local lualine = require("lualine")

			local colors = {
				bg = "#181818",
				fg = "#bbc2cf",
				cyan = "#008080",
				darkblue = "#081633",
				green = "#00d992",
				yellow = "#fbffad",
				orange = "#fb7f19",
				violet = "#a9a1e1",
				magenta = "#d3869b",
				blue = "#537D8D",
				red = "#ec5f67",
				white = "#ffffff",
			}

			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				hide_in_width = function()
					return vim.fn.winwidth(0) > 80
				end,
				check_git_workspace = function()
					local filepath = vim.fn.expand("%:p:h")
					local gitdir = vim.fn.finddir(".git", filepath .. ";")
					return gitdir and #gitdir > 0 and #gitdir < #filepath
				end,
			}

			local config = {
				options = {
					component_separators = "",
					section_separators = "",
					theme = {
						normal = { c = { fg = colors.fg, bg = colors.bg } },
						inactive = { c = { fg = colors.fg, bg = colors.bg } },
					},
				},
				sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
			}

			local function ins_left(component)
				table.insert(config.sections.lualine_c, component)
			end

			local function ins_right(component)
				table.insert(config.sections.lualine_x, component)
			end

			local mode_colors = function()
				local mode_color = {
					n = colors.yellow,
					i = colors.violet,

					v = colors.magenta,
					[""] = colors.magenta,
					V = colors.magenta,

					c = colors.orange,
					no = colors.red,
					s = colors.orange,
					S = colors.orange,
					[""] = colors.orange,
					ic = colors.yellow,
					R = colors.violet,
					Rv = colors.violet,
					cv = colors.red,
					ce = colors.red,
					r = colors.cyan,
					rm = colors.cyan,
					["r?"] = colors.cyan,
					["!"] = colors.red,
					t = colors.red,
				}

				return mode_color[vim.fn.mode()]
			end

			ins_left({
				"mode",
				icons_enabled = true,
				separator = "|",
				color = function()
					return { fg = mode_colors(), gui = "bold" }
				end,
			})

			ins_left({
				"filename",
				file_status = true,
				path = 1,
				cond = conditions.buffer_not_empty,
				color = { fg = colors.white, gui = "bold" },
			})

			ins_left({
				"filetype",
				icon_only = true,
				colored = true,
			})

			ins_right({
				"diagnostics",
				sources = { "nvim_diagnostic", "nvim_lsp" },

				sections = { "error", "warn", "info", "hint" },

				diagnostics_color = {
					error = "DiagnosticError", -- Changes diagnostics' error color.
					warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
					info = "DiagnosticInfo", -- Changes diagnostics' info color.
					hint = "DiagnosticHint", -- Changes diagnostics' hint color.
				},

				symbols = { error = "• ", warn = "• ", info = "• ", hint = "• " },
				colored = true, -- Displays diagnostics status in color if set to true.
				update_in_insert = false, -- Update diagnostics in insert mode.
				always_visible = false, -- Show diagnostics even if there are none.
			})

			ins_right({
				"branch",
				icon = "↳",
				color = { fg = colors.yellow, gui = "bold" },
			})

			ins_right({
				"location",
			})

			lualine.setup(config)
		end,
	},
}
