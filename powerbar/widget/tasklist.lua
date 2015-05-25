local capi = { screen = screen,
               client = client }
local client = require("awful.client")
local util = require("awful.util")
local tag = require("awful.tag")
local wibox = require("wibox")
local awful = require("awful")
local widget_common = require("awful.widget.common")
local segment = require("powerbar.segment")
local arrow = require("powerbar.arrow")
local beautiful = require("beautiful")
expander = require("powerbar.widget.expander")

local tasklist = { mt = {} }

-- implement segment interface
function tasklist:set_arrow_right(arr)
    self.arr_right = arr
    if arr then
        arr:set_color_left(self.color_right)
    end
end

function tasklist:set_arrow_left(arr)
    self.arr_left = arr
    if arr then
        arr:set_color_right(self.color_left)
    end
end

function tasklist:set_color(color)
    -- ignore, color is defined by the tasks
end

function tasklist:refresh_outer_arrows()
    if self.arr_left then
        self.arr_left:set_color_right(self.color_left)
    end
    if self.arr_right then
        self.arr_right:set_color_left(self.color_right)
    end
end

-- Copied from awful's tasklist.lua. Someone decided it would be best if it was a
-- local function <_<
local function tasklist_label(c, args)
    if not args then args = {} end
    local theme = beautiful.get()
    local fg_normal = args.fg_normal or theme.tasklist_fg_normal or theme.fg_normal or "#ffffff"
    local bg_normal = args.bg_normal or theme.tasklist_bg_normal or theme.bg_normal or "#000000"
    local fg_focus = args.fg_focus or theme.tasklist_fg_focus or theme.fg_focus
    local bg_focus = args.bg_focus or theme.tasklist_bg_focus or theme.bg_focus
    local fg_urgent = args.fg_urgent or theme.tasklist_fg_urgent or theme.fg_urgent
    local bg_urgent = args.bg_urgent or theme.tasklist_bg_urgent or theme.bg_urgent
    local fg_minimize = args.fg_minimize or theme.tasklist_fg_minimize or theme.fg_minimize
    local bg_minimize = args.bg_minimize or theme.tasklist_bg_minimize or theme.bg_minimize
    local bg_image_normal = args.bg_image_normal or theme.bg_image_normal
    local bg_image_focus = args.bg_image_focus or theme.bg_image_focus
    local bg_image_urgent = args.bg_image_urgent or theme.bg_image_urgent
    local bg_image_minimize = args.bg_image_minimize or theme.bg_image_minimize
    local tasklist_disable_icon = args.tasklist_disable_icon or theme.tasklist_disable_icon or false
    local font = args.font or theme.tasklist_font or theme.font or ""
    local bg = nil
    local text = "<span font_desc='"..font.."'>"
    local name = ""
    local bg_image = nil
    local focused = false

    -- symbol to use to indicate certain client properties
    local sticky = args.sticky or theme.tasklist_sticky or "▪"
    local ontop = args.ontop or theme.tasklist_ontop or '⌃'
    local floating = args.floating or theme.tasklist_floating or '✈'
    local maximized_horizontal = args.maximized_horizontal or theme.tasklist_maximized_horizontal or '⬌'
    local maximized_vertical = args.maximized_vertical or theme.tasklist_maximized_vertical or '⬍'

    if not theme.tasklist_plain_task_name then
        if c.sticky then name = name .. sticky end
        if c.ontop then name = name .. ontop end
        if client.floating.get(c) then name = name .. floating end
        if c.maximized_horizontal then name = name .. maximized_horizontal end
        if c.maximized_vertical then name = name .. maximized_vertical end
    end

    if c.minimized then
        name = name .. (util.escape(c.icon_name) or util.escape(c.name) or util.escape("<untitled>"))
    else
        name = name .. (util.escape(c.name) or util.escape("<untitled>"))
    end
    if capi.client.focus == c then
        focused = true
        bg = bg_focus
        bg_image = bg_image_focus
        if fg_focus then
            text = text .. "<span color='"..util.color_strip_alpha(fg_focus).."'>"..name.."</span>"
        else
            text = text .. "<span color='"..util.color_strip_alpha(fg_normal).."'>"..name.."</span>"
        end
    elseif c.urgent and fg_urgent then
        bg = bg_urgent
        text = text .. "<span color='"..util.color_strip_alpha(fg_urgent).."'>"..name.."</span>"
        bg_image = bg_image_urgent
    elseif c.minimized and fg_minimize and bg_minimize then
        bg = bg_minimize
        text = text .. "<span color='"..util.color_strip_alpha(fg_minimize).."'>"..name.."</span>"
        bg_image = bg_image_minimize
    else
        bg = bg_normal
        text = text .. "<span color='"..util.color_strip_alpha(fg_normal).."'>"..name.."</span>"
        bg_image = bg_image_normal
    end
    text = text .. "</span>"
    return text, bg, focused, not tasklist_disable_icon and c.icon or nil
end

local function my_update(w, buttons, label, data, tasks, args)
    -- reimplementation of common.list_update, customized for our purposes
    w:reset()
    local last_color = nil
    local last_a = nil
    local seen_focused = false
    for i, o in ipairs(tasks) do
        local cache = data[o]
        local tb, ib, bgb, m, l, a
        if cache then
            tb = cache.tb
            ib = cache.ib
            bgb = cache.bgb
            m = cache.m
            l = cache.l
            a = cache.a
        else
            tb = wibox.widget.textbox()
            ib = wibox.widget.imagebox()
            bgb = wibox.widget.background()
            m = wibox.layout.margin(tb, 4, 4)
            l = wibox.layout.fixed.horizontal()
            a = wibox.layout.align.horizontal()

            l:add(ib)
            l:add(m)
            l:add(expander())

            bgb:set_widget(l)

            bgb:buttons(widget_common.create_buttons(buttons, o))

            a:set_middle(bgb)

            data[o] = {
                tb = tb,
                ib = ib,
                bgb = bgb,
                m = m,
                l = l,
                a = a
            }
        end
        
        local text, color, focused, icon = tasklist_label(o, args)
        if color == nil then
            color = beautiful.bg_normal
        end
        if not pcall(tb.set_markup, tb, text) then
            tb:set_markup("<i>&lt;Invalid text&gt;</i>")
        end
        bgb:set_bg(color)
        ib:set_image(icon)

        if last_a then
            local arr = arrow(seen_focused)
            arr:set_color_left(last_color)
            arr:set_color_right(color)
            last_a:set_right(arr)
        else
            w.color_left = color
        end

        w:add(a)

        seen_focused = seen_focused or focused
        last_color = color
        last_a = a
    end

    if not last_a then
        w.color_left = beautiful.bg_normal
    end
    w.color_right = last_color or beautiful.bg_normal
    -- we update once before the object finishes constructing
    if w.refresh_outer_arrows then
        w:refresh_outer_arrows()
    end
end

local function new(screen, filter, buttons, style)
    local function update_func(w, b, l, d, o) return my_update(w, b, l, d, o, style) end
    local ret = awful.widget.tasklist(screen, filter, buttons, style, update_func)

    for k, v in pairs(tasklist) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret.color_left = beautiful.bg_normal
    ret.color_right = beautiful.bg_normal

    return ret
end

function tasklist.mt:__call(...)
    return new(...)
end

return setmetatable(tasklist, tasklist.mt)
