local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("Iosevka Nerd Font")
config.font_size = 11
config.colors = {}
config.colors.background = "#1D2021"
-- config.colors.background = "#181818"

config.window_close_confirmation = "NeverPrompt"
config.skip_close_confirmation_for_processes_named = {
	"bash",
	"sh",
	"zsh",
	"fish",
	"tmux",
}
config.enable_scroll_bar = true
config.window_padding = {
	left = 12,
	right = 12,
	top = 12,
	bottom = 12,
}
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.freetype_load_target = "HorizontalLcd"

local act = wezterm.action
local shell = os.getenv("SHELL")
local leader = "CTRL|SHIFT"
config.keys = {
	{
		key = "raw:49",
		mods = leader,
		action = act.SpawnTab({
			DomainName = "local",
		}),
	},
	{
		key = "n",
		mods = leader,
		action = act.SpawnTab({
			DomainName = "local",
		}),
	},

	{
		key = "t",
		mods = leader,
		action = wezterm.action.SplitPane({
			direction = "Down",
			command = { args = { shell } },
			size = { Percent = 30 },
		}),
	},

	{
		key = "w",
		mods = leader,
		action = act.CloseCurrentPane({
			confirm = false,
		}),
	},
	{
		key = ",",
		mods = leader,
		action = act.SpawnCommandInNewTab({
			cwd = os.getenv("WEZTERM_CONFIG_DIR"),
			set_environment_variables = {
				TERM = "screen-256color",
			},
			args = {
				"/usr/local/bin/nvim",
				os.getenv("WEZTERM_CONFIG_FILE"),
			},
		}),
	},
}
return config
