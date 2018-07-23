local capi = { screen = screen,
               client = client }
local client = require("awful.client")
local util = require("awful.util")
local tag = require("awful.tag")
local wibox = require("wibox")
local awful = require("awful")
local util  = require("awful.util")
local widget_common = require("awful.widget.common")
local segment = require("powerbar.segment")
local arrow = require("powerbar.arrow")
local beautiful = require("beautiful")
local expander = require("powerbar.widget.expander")

local tasklist = { mt = {} }

-- implement segment interface
function tasklist:set_arrow_right(arr)
    self._private.arr_right = arr
    if arr then
        arr.color_left = self._private.color_right
    end
end

function tasklist:set_arrow_left(arr)
    self._private.arr_left = arr
    if arr then
        arr.color_right = self._private.color_left
    end
end

function tasklist:set_color(color)
    -- ignore, color is defined by the tasks
end

function tasklist:refresh_outer_arrows()
    if self._private.arr_left then
        self._private.arr_left.color_right = self._private.color_left
    end
    if self._private.arr_right then
        self._private.arr_right.color_left = self._private.color_right
    end
end

-- Copied from awful's tasklist.lua. Someone decided it would be best if it was a
-- local function <_<
local function tasklist_label(c, args, tb)
    if not args then args = {} end
    local theme = beautiful.get()
    local align = args.align or theme.tasklist_align or "left"
    local fg_normal = util.ensure_pango_color(args.fg_normal or theme.tasklist_fg_normal or theme.fg_normal, "white")
    local bg_normal = args.bg_normal or theme.tasklist_bg_normal or theme.bg_normal or "#000000"
    local fg_focus = util.ensure_pango_color(args.fg_focus or theme.tasklist_fg_focus or theme.fg_focus, fg_normal)
    local bg_focus = args.bg_focus or theme.tasklist_bg_focus or theme.bg_focus or bg_normal
    local fg_urgent = util.ensure_pango_color(args.fg_urgent or theme.tasklist_fg_urgent or theme.fg_urgent, fg_normal)
    local bg_urgent = args.bg_urgent or theme.tasklist_bg_urgent or theme.bg_urgent or bg_normal
    local fg_minimize = util.ensure_pango_color(args.fg_minimize or theme.tasklist_fg_minimize or theme.fg_minimize, fg_normal)
    local bg_minimize = args.bg_minimize or theme.tasklist_bg_minimize or theme.bg_minimize or bg_normal
    local bg_image_normal = args.bg_image_normal or theme.bg_image_normal
    local bg_image_focus = args.bg_image_focus or theme.bg_image_focus
    local bg_image_urgent = args.bg_image_urgent or theme.bg_image_urgent
    local bg_image_minimize = args.bg_image_minimize or theme.bg_image_minimize
    local tasklist_disable_icon = args.tasklist_disable_icon or theme.tasklist_disable_icon or false
    local font = args.font or theme.tasklist_font or theme.font or ""
    local font_focus = args.font_focus or theme.tasklist_font_focus or theme.font_focus or font or ""
    local font_minimized = args.font_minimized or theme.tasklist_font_minimized or theme.font_minimized or font or ""
    local font_urgent = args.font_urgent or theme.tasklist_font_urgent or theme.font_urgent or font or ""
    local text = ""
    local name = ""
    local bg
    local bg_image
    local shape              = args.shape or theme.tasklist_shape
    local shape_border_width = args.shape_border_width or theme.tasklist_shape_border_width
    local shape_border_color = args.shape_border_color or theme.tasklist_shape_border_color

    -- symbol to use to indicate certain client properties
    local sticky = args.sticky or theme.tasklist_sticky or "▪"
    local ontop = args.ontop or theme.tasklist_ontop or '⌃'
    local above = args.above or theme.tasklist_above or '▴'
    local below = args.below or theme.tasklist_below or '▾'
    local floating = args.floating or theme.tasklist_floating or '✈'
    local maximized = args.maximized or theme.tasklist_maximized or '<b>+</b>'
    local maximized_horizontal = args.maximized_horizontal or theme.tasklist_maximized_horizontal or '⬌'
    local maximized_vertical = args.maximized_vertical or theme.tasklist_maximized_vertical or '⬍'

    tb:set_align(align)

    if not theme.tasklist_plain_task_name then
        if c.sticky then name = name .. sticky end

        if c.ontop then name = name .. ontop
        elseif c.above then name = name .. above
        elseif c.below then name = name .. below end

        if c.maximized then
            name = name .. maximized
        else
            if c.maximized_horizontal then name = name .. maximized_horizontal end
            if c.maximized_vertical then name = name .. maximized_vertical end
            if c.floating then name = name .. floating end
        end
    end

    if c.minimized then
        name = name .. (util.escape(c.icon_name) or util.escape(c.name) or util.escape("<untitled>"))
    else
        name = name .. (util.escape(c.name) or util.escape("<untitled>"))
    end

    local focused = capi.client.focus == c
    -- Handle transient_for: the first parent that does not skip the taskbar
    -- is considered to be focused, if the real client has skip_taskbar.
    if not focused and capi.client.focus and capi.client.focus.skip_taskbar
        and capi.client.focus:get_transient_for_matching(function(cl)
                                                             return not cl.skip_taskbar
                                                         end) == c then
        focused = true
    end

    if focused then
        bg = bg_focus
        text = text .. "<span color='"..fg_focus.."'>"..name.."</span>"
        bg_image = bg_image_focus
        font = font_focus

        if args.shape_focus or theme.tasklist_shape_focus then
            shape = args.shape_focus or theme.tasklist_shape_focus
        end

        if args.shape_border_width_focus or theme.tasklist_shape_border_width_focus then
            shape_border_width = args.shape_border_width_focus or theme.tasklist_shape_border_width_focus
        end

        if args.shape_border_color_focus or theme.tasklist_shape_border_color_focus then
            shape_border_color = args.shape_border_color_focus or theme.tasklist_shape_border_color_focus
        end
    elseif c.urgent then
        bg = bg_urgent
        text = text .. "<span color='"..fg_urgent.."'>"..name.."</span>"
        bg_image = bg_image_urgent
        font = font_urgent

        if args.shape_urgent or theme.tasklist_shape_urgent then
            shape = args.shape_urgent or theme.tasklist_shape_urgent
        end

        if args.shape_border_width_urgent or theme.tasklist_shape_border_width_urgent then
            shape_border_width = args.shape_border_width_urgent or theme.tasklist_shape_border_width_urgent
        end

        if args.shape_border_color_urgent or theme.tasklist_shape_border_color_urgent then
            shape_border_color = args.shape_border_color_urgent or theme.tasklist_shape_border_color_urgent
        end
    elseif c.minimized then
        bg = bg_minimize
        text = text .. "<span color='"..fg_minimize.."'>"..name.."</span>"
        bg_image = bg_image_minimize
        font = font_minimized

        if args.shape_minimized or theme.tasklist_shape_minimized then
            shape = args.shape_minimized or theme.tasklist_shape_minimized
        end

        if args.shape_border_width_minimized or theme.tasklist_shape_border_width_minimized then
            shape_border_width = args.shape_border_width_minimized or theme.tasklist_shape_border_width_minimized
        end

        if args.shape_border_color_minimized or theme.tasklist_shape_border_color_minimized then
            shape_border_color = args.shape_border_color_minimized or theme.tasklist_shape_border_color_minimized
        end
    else
        bg = bg_normal
        text = text .. "<span color='"..fg_normal.."'>"..name.."</span>"
        bg_image = bg_image_normal
    end
    tb:set_font(font)

    local other_args = {
        shape              = shape,
        shape_border_width = shape_border_width,
        shape_border_color = shape_border_color,
    }

    return text, bg, focused, bg_image, not tasklist_disable_icon and c.icon or nil, other_args
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
            a:set_right(nil)
        else
            tb = wibox.widget.textbox()
            ib = wibox.widget.imagebox()
            bgb = wibox.container.background()
            m = wibox.layout.margin(tb, 4, 4)
            l = wibox.layout.fixed.horizontal()
            a = wibox.layout.align.horizontal()

            l:add(ib)
            l:add(m)

            bgb.widget = l

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
        
        local text, color, focused, bg_image, icon = tasklist_label(o, args, tb)
        if color == nil then
            color = beautiful.bg_normal
        end
        if not tb:set_markup_silently(text) then
            tb:set_markup("<i>&lt;Invalid text&gt;</i>")
        end
        bgb:set_bg(color)
        ib:set_image(icon)

        if last_a then
            local arr = arrow(seen_focused)
            arr.color_left = last_color
            arr.color_right = color
            last_a:set_right(arr)
        else
            w._private.color_left = color
        end

        w:add(a)

        seen_focused = seen_focused or focused
        last_color = color
        last_a = a
    end

    if not last_a then
        w._private.color_left = beautiful.bg_normal
    end
    w._private.color_right = last_color or beautiful.bg_normal
    -- we update once before the object finishes constructing
    w:refresh_outer_arrows()
end
local naughty = require("naughty")
local function new(screen, filter, buttons, style)
    local function update_func(w, b, l, d, o) return my_update(w, b, l, d, o, style) end
    local ret = awful.widget.tasklist(screen, filter, buttons, style, update_func)

    util.table.crush(ret, tasklist, true)

    ret._private.color_left = beautiful.bg_normal
    ret._private.color_right = beautiful.bg_normal

    return ret
end

function tasklist.mt:__call(...)
    return new(...)
end

return setmetatable(tasklist, tasklist.mt)
