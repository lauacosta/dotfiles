pcall(require, "luarocks.loader")

local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")
require("awful.hotkeys_popup.keys")

if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end

-- BASIC CONFIG
beautiful.init("/home/lautaro/.config/awesome/theme.lua")
terminal = "wezterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

awful.layout.layouts = {
	-- awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	-- awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	-- awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	-- awful.layout.suit.max,
	-- awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
	-- awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,}
}
-- Load custom file configs
require("wibar")
require("keybindings")
require("rules")
require("signals")
