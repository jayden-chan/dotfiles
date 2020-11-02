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
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Get hostname of machine
local f = io.popen ("/bin/hostname")
hostname = f:read("*a") or ""
f:close()
hostname = string.gsub(hostname, "\n$", "")
xset = "xset r rate 270 35"

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(string.format("%s/.config/awesome/themes/rainbow/theme.lua", os.getenv("HOME")))

-- This is used later as the default terminal and editor to run.
terminal = "/usr/local/bin/st"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.

-- Alt
modkey = "Mod1"
-- Win
superkey = "Mod4"

-- {{{ Variables
scripts = "/home/jayden/Documents/Git/dotfiles/scripts"
spotifybasecommand = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player."
commandpp = spotifybasecommand .. "PlayPause"
commandnext = spotifybasecommand .. "Next"
commandprev = spotifybasecommand .. "Previous"
printvol = " | xargs sh -c 'notify-send -h \"int:value:$0\" Sound Volume:'"
brightnessnot = nil
volumenot = nil
-- }}}

-- Startup commands
awful.util.spawn("picom --config /home/jayden/.config/picom.conf", false)
awful.util.spawn("sh " .. scripts .. "/mouseaccel.sh", false)
awful.util.spawn(xset, false)

-- Set esc as caps lock on laptop
-- Caps lock is set as escape in keyboard firmware for desktop
if (hostname == "swift") then
    awful.util.spawn("xmodmap -e \"clear lock\"", false)
    awful.util.spawn("xmodmap -e \"keysym Caps_Lock = Escape\"", false)
end

if (hostname == "grace") then
    awful.util.spawn("hue profile apply bluepink", false)
end

if (hostname ~= "grace") then
    awful.util.spawn("nm-applet", false)
end

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.floating,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock('%a %b %d %l:%M ')

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end)
                )

local function set_wallpaper(s)
    awful.util.spawn("nitrogen --restore", false)
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons
    }

    local spotify_widget = wibox.widget.textbox()
    local command = "sh " .. scripts .. "/spotify.sh"

    awful.widget.watch(
        command, 1,
        function(widget, stdout, stderr, exitreason, exitcode)
            spotify_widget:set_text("   " .. stdout:gsub("^%s*(.-)%s*$", "%1"))
        end
    )

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 35})

    local battery_widget = nil
    if (hostname ~= "grace") then
        battery_widget = wibox.layout.margin(require("battery-widget") {
            ac = "AC",
            adapter = "BAT1",
            ac_prefix = "",
            battery_prefix = "",
            percent_colors = {
                { 20, "red"   },
                { 50, "orange"},
                {999, "green" },
            },
            listen = true,
            timeout = 30,
            widget_text = "${AC_BAT}${color_on}${percent}%${color_off}  ",
            widget_font = "Nimbus Sans 12",
            tooltip_text = "Battery ${state}${time_est}\nCapacity: ${capacity_percent}%",
            alert_threshold = 5,
            alert_timeout = 0,
            alert_title = "Low battery !",
            alert_text = "${AC_BAT}${time_est}"
        }.widget, 0, 0, 3, 0)
    end

    local systray = wibox.widget.systray()
    systray:set_base_size(25)

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            wibox.layout.margin(s.mytaglist, 0, 0, 3, 0),
            wibox.layout.margin(s.mypromptbox, 0, 0, 3, 0),
        },
        wibox.layout.margin(spotify_widget, 0, 0, 3, 0), -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.layout.margin(systray, 0, 5, 5, 0),
            battery_widget,
            wibox.layout.margin(mytextclock, 0, 0, 3, 0),
            wibox.layout.margin(s.mylayoutbox, 0, 0, 3, 0),
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "l",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "l", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({ superkey,         }, "k",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ superkey,         }, "j",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "k",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    awful.key({ modkey,           }, "i",     function () awful.util.spawn(xset, false)       end,
              {description = "set keyboard repeat delay and rate", group = "awesome"}),


    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ "Control" }, "space", function()
        awful.spawn.with_shell("bash " .. scripts .. "/rofi.sh --normal", false)
    end,
              {description = "show the menubar", group = "launcher"}),
    -- Volume Keys
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn.easy_async("ponymix decrease 3", function(stdout, stderr, exitreason, exitcode)
            volumenot = naughty.notify({text = "Volume: " .. math.floor(stdout + 0.5) .. "%", title = "Sound", replaces_id = volumenot}).id
        end)
    end),
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn.easy_async("ponymix increase 3", function(stdout, stderr, exitreason, exitcode)
            volumenot = naughty.notify({text = "Volume: " .. math.floor(stdout + 0.5) .. "%", title = "Sound", replaces_id = volumenot}).id
        end)
    end),
    awful.key({}, "XF86AudioMute", function ()
        awful.spawn.easy_async("ponymix toggle", function(tout, terr, texit, tcode)
            awful.spawn.easy_async("ponymix is-muted", function(mout, merr, mexit, mcode)
                if (mcode == 0) then
                    volumenot = naughty.notify({text = "Volume: Muted", title = "Sound", replaces_id = volumenot}).id
                else
                    volumenot = naughty.notify({text = "Volume: " .. math.floor(tout + 0.5) .. "%", title = "Sound", replaces_id = volumenot}).id
                end
            end)
        end)
    end),
    -- Media Keys
    awful.key({}, "XF86AudioPlay", function()
        awful.util.spawn(commandpp, false)
    end),
    awful.key({superkey}, "space", function()
        awful.util.spawn(commandpp, false)
    end),
    awful.key({}, "XF86AudioNext", function()
        awful.util.spawn(commandnext, false)
    end),
    awful.key({}, "XF86AudioPrev", function()
        awful.util.spawn(commandprev, false)
    end),
    -- Screenshots
    awful.key({}, "Print", function()
        awful.util.spawn("sh " .. scripts .. "/screenshot.sh", false)
    end),
    awful.key({superkey, "Shift"}, "s", function()
        awful.util.spawn("sh " .. scripts .. "/screenshot.sh", false)
    end),
    awful.key({"Shift"}, "Print", function()
        awful.util.spawn("sh " .. scripts .. "/screenshot.sh --monitor", false)
    end),
    -- Brightness keys
    awful.key({}, "XF86MonBrightnessUp", function()
        awful.spawn.easy_async("light -G", function(stdout, stderr, exitreason, exitcode)
            brightness = tonumber(stdout) + 0.5 - (tonumber(stdout) + 0.5) % 1
            if (brightness < 10) then
                awful.spawn("light -A 1", false)
                brightness = brightness + 1
            elseif (brightness < 25) then
                awful.spawn("light -A 3", false)
                brightness = brightness + 3
            elseif (brightness < 100) then
                awful.spawn("light -A 5", false)
                brightness = brightness + 5
            end
            brightnessnot = naughty.notify({text = "Brightness: " .. brightness .. "%", title = "Screen", replaces_id = brightnessnot}).id
        end)
    end),
    awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn.easy_async("light -G", function(stdout, stderr, exitreason, exitcode)
            brightness = tonumber(stdout) + 0.5 - (tonumber(stdout) + 0.5) % 1
            if (brightness <= 10) then
                awful.spawn("light -U 1", false)
                brightness = brightness - 1
            elseif (brightness <= 25) then
                awful.spawn("light -U 3", false)
                brightness = brightness - 3
            elseif (brightness > 0) then
                awful.spawn("light -U 5", false)
                brightness = brightness - 5
            end
            brightnessnot = naughty.notify({text = "Brightness: " .. brightness .. "%", title = "Screen", replaces_id = brightnessnot}).id
        end)
    end),
    -- Power menu
    awful.key({"Control", modkey}, "Delete", function()
        awful.spawn.with_shell("bash " .. scripts .. "/rofi.sh --power", false)
    end),
    -- Lock shortcut
    awful.key({superkey}, "l", function()
        awful.spawn("dm-tool lock", false)
    end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                            end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                        ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster())    end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen(c.screen.index+1)  end,
              {description = "move to next screen", group = "client"}),
    awful.key({ modkey,           }, "p",      function (c) c:move_to_screen(c.screen.index-1)  end,
              {description = "move to previous screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop               end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ superkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "Nautilus",
          "Nitrogen",
          "hue_ui",
          "feh",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
