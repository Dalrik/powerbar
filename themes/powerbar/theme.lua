---------------------------
-- Default awesome theme --
---------------------------

theme = {}

-- Todo:  Change the $USER to yourself.
pathToConfig = "~/.config/awesome/themes/"

theme.font          = "Source Sans Semibold 8"

theme.bg_normal     = "#181818" -- base 00
theme.bg_focus      = "#a1b56C"
theme.bg_urgent     = "#ab4642"
theme.bg_systray    = theme.bg_normal
theme.bg_minimize   = "#DC9656"

theme.tasklist_bg_normal = "#7cafc2"
theme.tasklist_fg_normal = "#282828"

theme.fg_normal     = "#D8D8D8" -- base 05
theme.fg_focus      = "#282828"
theme.fg_urgent     = "#282828"
theme.fg_minimize   = "#282828"

theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.fg_clock      = "#EEEEEE"
theme.bg_clock      = "#777E76"

theme.fg_prompt     = "#181818"
theme.bg_prompt     = "#E8E8E8"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"
theme.taglist_bg_focus = "#a1b56c" -- base 0B
theme.taglist_fg_focus = "#282828" -- Base 01
theme.taglist_bg_occupied = "#7cafc2" -- base 0D
theme.taglist_fg_occupied = "#282828" -- base 01
theme.taglist_bg_urgent = "#ab4642" -- base 08
theme.taglist_fg_urgent = "#282828"
theme.taglist_bg_empty = "#383838"
-- Le hax here to get font centered vertically
theme.taglist_font = "Source Code Pro Semibold 12' rise='50"

-- Display the taglist squares
--theme.taglist_squares_sel   = pathToConfig .. "powerbar/icons/square_sel.png"
--theme.taglist_squares_unsel = pathToConfig .. "powerbar/icons/square_unsel.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = 15
theme.menu_width  = 100

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

theme.wallpaper = "/home/ian/background.jpg"

-- You can use your own layout icons like this:
theme.layout_floating  = pathToConfig .. "powerbar/layouts/floating.png"
theme.layout_tilebottom = pathToConfig .. "/powerbar/layouts/tilebottom.png"
theme.layout_tileleft   = pathToConfig .. "powerbar/layouts/tileleft.png"
theme.layout_tile = pathToConfig .. "powerbar/layouts/tile.png"
theme.layout_tiletop = pathToConfig .. "powerbar/layouts/tiletop.png"

-- Arrow generation templates
theme.arrTemplate = pathToConfig .. "powerbar/icons/arrow.png"
theme.arrAltTemplate = pathToConfig .. "powerbar/icons/arrowAlt.png"

-- The clock icon:
theme.clock = pathToConfig .. "powerbar/icons/myclocknew.png"

--{{ For the wifi widget icons }} --
theme.nethigh = pathToConfig .. "powerbar/icons/nethigh.png"
theme.netmedium = pathToConfig .. "powerbar/icons/netmedium.png"
theme.netlow = pathToConfig .. "powerbar/icons/netlow.png"

--{{ For the battery icon }} --
theme.baticon = pathToConfig .. "powerbar/icons/battery.png"

--{{ For the hard drive icon }} --
theme.fsicon = pathToConfig .. "powerbar/icons/hdd.png"

--{{ For the volume icons }} --
theme.mute = pathToConfig .. "powerbar/icons/mute.png"
theme.music = pathToConfig .. "powerbar/icons/music.png"

--{{ For the volume icon }} --
theme.mute = pathToConfig .. "powerbar/icons/volmute.png"
theme.volhi = pathToConfig .. "powerbar/icons/volhi.png"
theme.volmed = pathToConfig .. "powerbar/icons/volmed.png"
theme.vollow = pathToConfig .. "powerbar/icons/vollow.png"

--{{ For the CPU icon }} --
theme.cpuicon = pathToConfig .. "powerbar/icons/cpu.png"

--{{ For the memory icon }} --
theme.mem = pathToConfig .. "powerbar/icons/mem.png"

--{{ For the memory icon }} --
theme.mail = pathToConfig .. "powerbar/icons/mail.png"
theme.mailopen = pathToConfig .. "powerbar/icons/mailopen.png"


-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
