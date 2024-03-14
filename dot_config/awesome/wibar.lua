local lain = require("lain")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
require("awful.hotkeys_popup.keys")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function set_wallpaper(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

screen.connect_signal("property::geometry", set_wallpaper)

local markup = lain.util.markup

local mykeyboardlayout = awful.widget.keyboardlayout()

local clock = awful.widget.watch("date +'%a %d %b %R'", 60, function(widget, stdout)
	widget:set_markup(" " .. markup.font(beautiful.font, stdout))
end)

local memicon = wibox.widget.imagebox(beautiful.widget_mem)
local mem = lain.widget.mem({
	settings = function()
		mem_used = string.format("%.1f", mem_now.used / 1024)
		widget:set_markup(markup.font(beautiful.font, " RAM: " .. mem_used .. "GB "))
	end,
})

local cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
local cpu = lain.widget.cpu({
	settings = function()
		widget:set_markup(markup.font(beautiful.font, " CPU: " .. cpu_now.usage .. "% "))
	end,
})

local volicon = wibox.widget.imagebox(beautiful.widget_vol)
beautiful.volume = lain.widget.alsa({
	settings = function()
		if volume_now.status == "off" then
			volicon:set_image(beautiful.widget_vol_mute)
		elseif tonumber(volume_now.level) == 0 then
			volicon:set_image(beautiful.widget_vol_no)
		elseif tonumber(volume_now.level) <= 50 then
			volicon:set_image(beautiful.widget_vol_low)
		else
			volicon:set_image(beautiful.widget_vol)
		end

		widget:set_markup(markup.font(beautiful.font, " ♪: " .. volume_now.level .. "% "))
	end,
})
beautiful.volume.widget:buttons(awful.util.table.join(
	awful.button({}, 4, function()
		awful.util.spawn("amixer set Master 1%+")
		beautiful.volume.update()
	end),
	awful.button({}, 5, function()
		awful.util.spawn("amixer set Master 1%-")
		beautiful.volume.update()
	end)
))

local spr = wibox.widget.textbox("  ")

awful.screen.connect_for_each_screen(function(s)
	set_wallpaper(s)

	local names = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
	local l = awful.layout.suit
	awful.tag(names, s, l.tile.left)

	s.mypromptbox = awful.widget.prompt()

	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	})

	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		height = dpi(22),
		bg = beautiful.bg_normal,
		fg = beautiful.fg_normal,
	})
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,

			s.mytaglist,
			s.mypromptbox,
		},
		{
			{
				align = "center",
				widget = clock,
			},
			-- s.mytasklist,
			layout = wibox.layout.constraint,
		},
		{
			layout = wibox.layout.fixed.horizontal,
			mykeyboardlayout,

			volicon,
			beautiful.volume.widget,

			memicon,
			mem.widget,
			cpuicon,
			cpu.widget,
			spr,
			wibox.widget.systray(),
			spr,
			s.mylayoutbox,
		},
	})
end)
