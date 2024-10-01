-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local lain = require("lain")

-- sometimes the screen numbers get messed up and the directions/numbers
-- need to change. no idea how to make the screen numbers consistent
local screen_num_invert = true

naughty.config.spacing = 1
naughty.config.padding = 10
naughty.config.defaults.position = "bottom_right"
naughty.config.defaults.margin = 8

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
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
			width = nil,
			max_width = 800,
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
local terminal = "st"
local editor = os.getenv("EDITOR") or "nvim"
local host = os.getenv("HOSTNAME") or "grace"
local editor_cmd = terminal .. " -e " .. editor

local home = os.getenv("HOME")
local dots = os.getenv("DOT")
local scripts = dots .. "/scripts"
local icon_path = dots .. "/awesome/theme/default/"

beautiful.init(home .. "/.config/awesome/theme/default/theme.lua")

-- Alt
local modkey = "Mod1"
-- Super (windows key)
local super = "Mod4"

-- Autostart programs
awful.spawn(scripts .. "/autostart.sh", false)

-- Spawn the MPRIS listener script
local start_mpris = function()
	awful.spawn.with_line_callback("spotify-dbus-mon", {
		stdout = function(line)
			awesome.emit_signal("mpris", line:gsub("%s+$", ""))
		end,
		stderr = function(line)
			naughty.notify({ text = "MPRIS Error: " .. line })
		end,
	})
end

local find_mpris_cmd = "ps -ax | rg '(\\d+).*?\\d spotify-dbus-mon' --only-matching --replace='$1' --color=never"

-- Restart the MPRIS listener script and setup the global signal handler
-- for the widget to consume
awful.spawn.easy_async_with_shell(find_mpris_cmd, function(stdout, _, _, exit_code)
	if exit_code == 0 then
		local kill_args = { "kill" }
		for line in string.gmatch(stdout, "[^\r\n]+") do
			table.insert(kill_args, line)
		end
		awful.spawn.easy_async(kill_args, function()
			start_mpris()
		end)
	else
		start_mpris()
	end
end)

local script = function(name, args, startup_notifications)
	local full_args = { scripts .. "/" .. name }
	for _, v in pairs(args) do
		table.insert(full_args, v)
	end
	awful.spawn(full_args, startup_notifications or false)
end

local script_cb = function(name, args, startup_notifications)
	return function()
		script(name, args, startup_notifications)
	end
end

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.top,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

local mypowermenu = {
	{
		"logout",
		function()
			script("rofi.sh", { "--power_fast", "logout" }, false)
		end,
	},
	{
		"lock",
		function()
			script("rofi.sh", { "--power_fast", "lock" }, false)
		end,
	},
	{
		"reboot",
		function()
			script("rofi.sh", { "--power_fast", "reboot" }, false)
		end,
	},
	{
		"shutdown",
		function()
			script("rofi.sh", { "--power_fast", "shutdown" }, false)
		end,
	},
}

local mymainmenu = awful.menu({
	items = {
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "power menu", mypowermenu },
		{ "open terminal", terminal },
		{
			"rofi",
			function()
				script("rofi.sh", { "--normal" }, false)
			end,
		},
	},
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar

-- Create a wibox for each screen and add it
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
	awful.button({}, 5, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local bar_bg = "#202022"
local mar = function(w, top, right, bottom, left)
	return wibox.container.margin(w, left or 0, right or 0, top or 0, bottom or 0)
end

local icon = function(icon, hor, ver)
	local image = wibox.widget.imagebox(icon_path .. icon .. ".png", true)
	local wid = wibox.container.background()
	wid.bg = bg or "#ffffff"
	wid.shape = gears.shape.rect
	wid.widget = mar(image, ver or 9, hor or 14, ver or 9, hor or 14)
	wid.visible = true

	return wid
end

local icob = function(ico, widget)
	local layout = wibox.layout.fixed.horizontal()
	layout:add(ico)
	layout:add(widget)

	local wid = wibox.container.background()
	wid.bg = bar_bg
	wid.shape = gears.shape.rect
	wid.widget = layout

	return wid
end

local bg = function(widget)
	local wid = wibox.container.background()
	wid.bg = bar_bg
	wid.shape = gears.shape.rect
	wid.widget = widget
	wid.visible = true
	return wid
end

local widget_block_gap = 11
local weather_text = wibox.widget({ widget = wibox.widget.textbox })
local weather = mar(icob(icon("cloud", 12, 10), mar(weather_text, 0, 10, 0, 10)), 0, widget_block_gap)
awful.widget.watch(scripts .. "/weather.sh", 30, function(_, stdout)
	weather_text:set_text(stdout:gsub("%s+$", ""))
end)

weather:buttons(gears.table.join(
	weather:buttons(),
	awful.button({}, 1, nil, function()
		awful.spawn(scripts .. "/weather.sh --open")
	end)
))

local dnd_text = wibox.widget({ widget = wibox.widget.textbox })
dnd_text:set_text("Do Not Disturb")
local dnd_widget = mar(icob(icon("volume-xmark"), mar(dnd_text, 0, 10, 0, 10)), 0, widget_block_gap)
dnd_widget:set_visible(false)
naughty.resume()

local headphones_text = wibox.widget({ widget = wibox.widget.textbox })
local headphones = mar(icob(icon("headphones", 13, 10), mar(headphones_text, 0, 10, 0, 10)), 0, widget_block_gap)
awful.widget.watch(scripts .. "/bt-battery.sh 'Focal Bathys'", 60, function(_, stdout)
	local data = stdout:gsub("%s+$", "")
	if string.len(data) == 0 then
		headphones:set_visible(false)
	else
		headphones_text:set_text(data .. "%")
		headphones:set_visible(true)
	end
end)

awful.screen.connect_for_each_screen(function(s)
	-- Each screen has its own tag table.
	if s.index == 1 then
		-- The main screen uses tile.left layout by default
		awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
	else
		-- The side screen uses tile.top by default
		awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[2])
	end

	-- Create a textclock widget
	s.textclock_local = wibox.widget.textclock("%a, %b %e %l:%M %p")
	s.month_calendar = awful.widget.calendar_popup.month({
		screen = s,
		start_sunday = true,
		margin = 15,
	})
	s.month_calendar:attach(s.textclock_local, "tr")

	s.mytaglist = wibox.container.background()
	s.mytaglist.bg = bar_bg
	s.mytaglist.shape = gears.shape.rect
	s.mytaglist.widget = mar(
		awful.widget.taglist({
			screen = s,
			filter = function(t)
				return t.selected or #t:clients() > 0
			end,
			buttons = taglist_buttons,
		}),
		0,
		8,
		0,
		8
	)

	s.mywibox = awful.wibar({
		bg = "#00000000",
		position = "top",
		screen = s,
		height = 45,
	})

	local os_icon = icon("nix", 11, 7)

	local mem_widget = wibox.widget({ widget = wibox.widget.textbox })
	lain.widget.mem({
		timeout = 5,
		settings = function()
			-- mem_now variable magically appears in this function
			-- https://github.com/lcpz/lain/wiki/mem
			---@diagnostic disable-next-line: undefined-global
			mem_widget:set_text(mem_now.perc .. "%")
		end,
	})

	local cpu_widget = wibox.widget({ widget = wibox.widget.textbox })
	lain.widget.cpu({
		timeout = 5,
		settings = function()
			-- cpu_now variable magically appears in this function
			-- https://github.com/lcpz/lain/wiki/cpu
			---@diagnostic disable-next-line: undefined-global
			cpu_widget:set_text(cpu_now.usage .. "%")
		end,
	})

	local mpris_text = wibox.widget({ widget = wibox.widget.textbox })
	local mpris_block = mar(icob(icon("circle-play", 13), mar(mpris_text, 0, 10, 0, 10)), 0, 0, 0, widget_block_gap)
	mpris_block:set_visible(false)

	-- Subscribe to the MPRIS signal from the listener script
	local mpris_toggle_func = function(data)
		if string.len(data:gsub("%s+$", "")) == 0 then
			mpris_block:set_visible(false)
		else
			mpris_text:set_text(data)
			mpris_block:set_visible(true)
		end
	end

	awesome.disconnect_signal("mpris", mpris_toggle_func)
	awesome.connect_signal("mpris", mpris_toggle_func)

	local mem = mar(icob(icon("floppy-disk", 14, 8), mar(mem_widget, 0, 10, 0, 10)), 0, widget_block_gap)
	local cpu = mar(icob(icon("chart-line"), mar(cpu_widget, 0, 10, 0, 10)), 0, widget_block_gap)
	local time_local = icob(icon("clock", 12), mar(s.textclock_local, 0, 10, 0, 10))

	local right = wibox.layout.fixed.horizontal()

	if s == screen.primary then
		local systray = wibox.widget.systray()
		systray:set_screen(s)

		right:add(mem)
		right:add(cpu)
		right:add(weather)
		right:add(headphones)
		right:add(dnd_widget)
		right:add(time_local)
		right:add(mar(bg(mar(systray, 8, 8, 8, 10)), 0, 0, 0, widget_block_gap))
	else
		right:add(weather)
		right:add(headphones)
		right:add(dnd_widget)
		right:add(time_local)
	end

	local left = wibox.layout.fixed.horizontal()
	left:add(os_icon)
	left:add(s.mytaglist)
	left:add(mpris_block)

	-- Add widgets to the wibox
	s.mywibox:struts({ top = 35, left = 0, right = 0, bottom = 0 })
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		expand = "inside",
		mar(left, 10, 0, 0, 20),
		mar(wibox.container.background(), 1),
		mar(right, 10, 20),
	})
end)
-- }}}

-- {{{ Global mouse bindings
root.buttons(gears.table.join(awful.button({}, 3, function()
	mymainmenu:toggle()
end)))
-- }}}

-- {{{ Key bindings
local globalkeys = gears.table.join(
	-- Alt+tab but for tags
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "previous tag", group = "tag" }),

	awful.key({ modkey }, "h", function()
		hotkeys_popup.show_help(nil, awful.screen.focused())
	end, { description = "show hotkey list", group = "awesome" }),

	-- Do not disturb
	awful.key({ modkey }, "d", function()
		if naughty.is_suspended() then
			naughty.resume()
			dnd_widget:set_visible(false)
		else
			naughty.suspend()
			dnd_widget:set_visible(true)
		end
	end, { description = "toggle mute notifications", group = "awesome" }),

	awful.key({ modkey }, "r", function()
		awful.spawn.with_shell("kill -TERM $(pgrep -f 'target/debug/lakehouse-server')")
	end, { description = "shutdown lakehouse", group = "awesome" }),

	-- Screenshots
	awful.key(
		{ super, "Control" },
		"s",
		script_cb("rofi.sh", { "--save-screenshot" }, false),
		{ description = "save screenshot prompt", group = "screenshot" }
	),

	awful.key(
		{ super, "Shift" },
		"s",
		script_cb("screenshot.sh", { "--select" }, false),
		{ description = "screenshot selected area", group = "screenshot" }
	),

	awful.key(
		{ super, "Shift" },
		"a",
		script_cb("screenshot.sh", { "--qr" }, false),
		{ description = "scan QR code", group = "screenshot" }
	),

	awful.key(
		{},
		"Print",
		script_cb("screenshot.sh", {}, false),
		{ description = "screenshot all screens", group = "screenshot" }
	),

	awful.key(
		{ modkey },
		"c",
		script_cb("xcolor.sh", {}, false),
		{ description = "activate color picker", group = "screenshot" }
	),

	awful.key(
		{ modkey, "Shift" },
		"F1",
		script_cb("rofi.sh", { "--autorandr" }, false),
		{ description = "select autorandr profile", group = "misc" }
	),

	awful.key(
		{ modkey, "Shift" },
		"F2",
		script_cb("rofi.sh", { "--liquidctl" }, false),
		{ description = "cycle cooling control settings", group = "misc" }
	),

	awful.key({ modkey, "Shift" }, "F11", function()
		awful.spawn.with_shell("killall -SIGUSR1 gpu-screen-recorder")
	end, { description = "save clip", group = "misc" }),

	-- XF86
	awful.key(
		{},
		"XF86AudioPlay",
		script_cb("xf86.sh", { "media", "PlayPause" }),
		{ description = "play/pause", group = "media" }
	),

	awful.key(
		{},
		"XF86AudioPrev",
		script_cb("xf86.sh", { "media", "Previous" }),
		{ description = "previous", group = "media" }
	),

	awful.key({}, "XF86AudioNext", script_cb("xf86.sh", { "media", "Next" }), { description = "next", group = "media" }),

	awful.key(
		{},
		"XF86AudioRaiseVolume",
		script_cb("xf86.sh", { "vol", "up" }),
		{ description = "increase volume", group = "media" }
	),

	awful.key(
		{},
		"XF86AudioLowerVolume",
		script_cb("xf86.sh", { "vol", "down" }),
		{ description = "lower volume", group = "media" }
	),

	awful.key({}, "XF86AudioMute", script_cb("xf86.sh", { "vol", "mute" }), { description = "mute", group = "media" }),

	awful.key(
		{},
		"XF86MonBrightnessUp",
		script_cb("xf86.sh", { "light", "up" }),
		{ description = "increase backlight brightness", group = "media" }
	),

	awful.key(
		{},
		"XF86MonBrightnessDown",
		script_cb("xf86.sh", { "light", "down" }),
		{ description = "decrease backlight brightness", group = "media" }
	),

	-- Inputs
	awful.key(
		{ modkey },
		"u",
		script_cb("inputs.sh", {}, false),
		{ description = "jump to urgent client", group = "client" }
	),

	-- Layout manipulation
	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the next screen", group = "screen" }),

	awful.key({ modkey, "Control" }, "l", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the previous screen", group = "screen" }),

	awful.key({ modkey }, "bracketleft", function()
		awful.layout.inc(-1)
	end, { description = "switch to the previous layout", group = "screen" }),

	awful.key({ modkey }, "bracketright", function()
		awful.layout.inc(1)
	end, { description = "switch to the next layout", group = "screen" }),

	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "previous client", group = "client" }),

	-- Standard program
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),

	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),

	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),

	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),

	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),

	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),

	awful.key(
		{ modkey },
		"space",
		script_cb("rofi.sh", { "--normal" }, false),
		{ description = "open run prompt", group = "launcher" }
	),

	awful.key(
		{ modkey },
		"w",
		script_cb("rofi.sh", { "--window" }, false),
		{ description = "open window switcher prompt", group = "launcher" }
	),

	awful.key(
		{ modkey, "Control" },
		"Delete",
		script_cb("rofi.sh", { "--power" }),
		{ description = "open power menu", group = "launcher" }
	),

	-- Directional focus
	awful.key({ super }, "j", function()
		awful.client.focus.bydirection("left")
	end, { description = "focus client to left", group = "layout" }),

	awful.key({ super }, "l", function()
		awful.client.focus.bydirection("right")
	end, { description = "focus client to right", group = "layout" }),

	awful.key({ super }, "k", function()
		awful.client.focus.bydirection("down")
	end, { description = "focus client below", group = "layout" }),

	awful.key({ super }, "i", function()
		awful.client.focus.bydirection("up")
	end, { description = "focus client above", group = "layout" }),

	-- Directional swap
	awful.key({ super, "Shift" }, "j", function()
		awful.client.swap.bydirection("left")
	end, { description = "swap with client to left", group = "layout" }),

	awful.key({ super, "Shift" }, "l", function()
		awful.client.swap.bydirection("right")
	end, { description = "swap with client to right", group = "layout" }),

	awful.key({ super, "Shift" }, "k", function()
		awful.client.swap.bydirection("down")
	end, { description = "swap with client below", group = "layout" }),

	awful.key({ super, "Shift" }, "i", function()
		awful.client.swap.bydirection("up")
	end, { description = "swap with client above", group = "layout" })
)

local clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),

	awful.key({ modkey, "Shift" }, "q", function(c)
		c:kill()
	end, { description = "close", group = "client" }),

	awful.key({ modkey }, "s", awful.client.floating.toggle, { description = "toggle floating", group = "client" }),

	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),

	awful.key({ modkey }, "o", function(c)
		c:move_to_screen(c.screen.index + (screen_num_invert and -1 or 1))
	end, { description = "move to previous screen", group = "client" }),

	awful.key({ modkey }, "p", function(c)
		c:move_to_screen(c.screen.index - (screen_num_invert and -1 or 1))
	end, { description = "move to next screen", group = "client" }),

	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),

	awful.key({ modkey, "Control" }, "t", function(c)
		awful.titlebar.toggle(c)
	end, { description = "toggle title bar", group = "client" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	awful.key({ modkey }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "minimize", group = "client" }),

	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Move client to tag
		awful.key({ super, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" })
	)
end

local clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

root.keys(globalkeys)

awful.rules.rules = {
	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },
	-- All clients
	{
		rule = {},
		properties = {
			border_width = 0,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			titlebars_enabled = false,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen + awful.placement.centered,
		},
	},
	{
		rule_any = {
			{ type = "dock" },
			{ type = "splash" },
			{ type = "menu" },
			{ type = "toolbar" },
			{ type = "utility" },
			{ type = "dropdown_menu" },
			{ type = "popup_menu" },
			{ type = "notification" },
			{ type = "combo" },
			{ type = "dnd" },
		},
		properties = {
			titlebars_enabled = false,
		},
	},
	-- KDE connect pointer
	{
		rule_any = {
			class = {
				"kdeconnectd",
				"kdeconnect.daemon",
			},
		},
		properties = {
			floating = true,
			titlebars_enabled = false,
		},
	},
	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA",
				"copyq",
				"pinentry",
			},
			class = {
				"Arandr",
				"BigMeter",
				"Blueman-manager",
				".blueman-manager-wrapped",
				"Eog",
				"File-roller",
				"file-roller",
				"mousepad",
				"Mousepad",
				"Gpick",
				"Jalv.gtk3",
				"Kruler",
				"MessageWin",
				"Nitrogen",
				"Org.gnome.Nautilus",
				"Nsxiv",
				"Tor Browser",
				"Inkview",
				"Wpa_gui",
				"mpv",
				"origin.exe",
				"pw-display",
				"nvidia-settings",
				"Nvidia-settings",
				"NVIDIA settings",
				"veromix",
				"eadesktop.exe",
				"Thunar",
				"xtightvncviewer",
			},
			name = {
				"Event Tester", -- xev.
				"Steam Guard - Computer Authorization Required",
				"Friends List",
				"xzoom x1",
				"xzoom x2",
				"xzoom x3",
				"xzoom x4",
				"xzoom x5",
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},
	-- Psensor on side screen
	{
		rule = { class = "Psensor" },
		properties = { screen = 2, tag = "2" },
	},
	-- Carla on side screen
	{
		rule = { class = "Carla2" },
		properties = { screen = host == "grace" and 2 or 1, tag = host == "grace" and "2" or "9" },
	},
	-- Trackmania
	{ rule = { class = "steam_app_2225070" }, properties = { screen = 1, tag = "3" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end

	if not c.maximized and not c.fullscreen then
		if c.floating and c.requests_no_titlebar ~= true and (c.type == "normal" or c.type == "dialog") then
			awful.titlebar.show(c)
		else
			awful.titlebar.hide(c)
		end
	end
end)

client.connect_signal("property::floating", function(c)
	if not c.maximized and not c.fullscreen then
		if c.floating and c.requests_no_titlebar ~= true and (c.type == "normal" or c.type == "dialog") then
			awful.titlebar.show(c)
		else
			awful.titlebar.hide(c)
		end
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	local titlebar_size = 40
	local icon_size = 16
	local titlebar = awful.titlebar(c, { size = titlebar_size })

	titlebar:setup({
		{
			{ -- Left
				awful.titlebar.widget.iconwidget(c),
				buttons = buttons,
				layout = wibox.layout.fixed.horizontal,
			},
			left = titlebar_size / 3,
			right = 5,
			top = (titlebar_size - icon_size) / 2,
			bottom = (titlebar_size - icon_size) / 2,
			layout = wibox.container.margin,
		},
		{ -- Middle
			{ -- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{
			{ -- Right
				{
					awful.titlebar.widget.stickybutton(c),
					right = 4,
					layout = wibox.container.margin,
				},
				{
					awful.titlebar.widget.maximizedbutton(c),
					left = 4,
					right = 4,
					layout = wibox.container.margin,
				},
				{
					awful.titlebar.widget.closebutton(c),
					left = 4,
					layout = wibox.container.margin,
				},
				layout = wibox.layout.fixed.horizontal(),
			},
			left = 5,
			right = titlebar_size / 3,
			top = (titlebar_size - icon_size) / 2,
			bottom = (titlebar_size - icon_size) / 2,
			layout = wibox.container.margin,
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

-- }}}
