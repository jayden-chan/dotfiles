---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- local gfs = require("gears.filesystem")
-- local themes_path = gfs.get_themes_dir()
local themes_path = "~/.config/dotfiles/awesome/theme/"

local theme = {}

theme.font = "Sans 10"
theme.notification_font = "Sans 12"

local main_bg = "#1e2122"
local font_fg = "#bbbbbb"
local white = "#ffffff"

theme.bg_normal = "#222222"
theme.bg_focus = "#212121"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = 5

theme.fg_normal = font_fg
theme.fg_focus = white
theme.fg_urgent = white
theme.fg_minimize = white

theme.useless_gap = 10
theme.gap_single_client = true
theme.border_width = 0
theme.border_normal = "#000000"
theme.border_focus = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
theme.titlebar_bg_focus = main_bg
theme.titlebar_bg_normal = main_bg
theme.titlebar_fg_focus = white
theme.titlebar_fg_normal = font_fg
theme.taglist_bg_focus = main_bg
theme.taglist_bg_normal = main_bg
theme.taglist_fg = font_fg
theme.taglist_fg_focus = white

-- Generate taglist squares:
theme.taglist_squares_sel = nil
theme.taglist_squares_unsel = nil

-- Variables set for theming notifications:
theme.notification_bg = main_bg
theme.notification_fg = font_fg
theme.notification_width = 400
theme.notification_icon_size = 80
theme.notification_margin = 10
-- theme.notification_[border_color|border_width|shape|opacity]
theme.notification_border_color = main_bg
theme.notification_border_width = 0

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(25)
theme.menu_width = dpi(200)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "default/red_unfocused.png"
theme.titlebar_close_button_focus = themes_path .. "default/red.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/yellow_unfocused.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "default/yellow.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "default/yellow_unfocused.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "default/yellow.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/green_unfocused.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "default/green.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "default/green_unfocused.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "default/green.png"

theme.wallpaper = themes_path .. "default/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
