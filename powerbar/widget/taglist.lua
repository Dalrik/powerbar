local wibox = require("wibox")
local awful = require("awful")
local widget_common = require("awful.widget.common")
local segment = require("powerbar.segment")
local arrow = require("powerbar.arrow")
local beautiful = require("beautiful")

local taglist = { mt = {} }

-- implement segment interface
function taglist:set_arrow_right(arr)
    self.arr_right = arr
    if arr then
        arr:set_color_left(self.color_right)
    end
end

function taglist:set_arrow_left(arr)
    self.arr_left = arr
    if arr then
        arr:set_color_right(self.color_left)
    end
end

function taglist:set_color(color)
    -- ignore, color is defined by the state of the tags
end

function taglist:refresh_outer_arrows()
    if self.arr_left then
        self.arr_left:set_color_right(self.color_left)
    end
    if self.arr_right then
        self.arr_right:set_color_left(self.color_right)
    end
end

local function my_update(w, buttons, label, data, tags, args)
    -- reimplementation of common.list_update, customized for our purposes
    w:reset()
    local last_color = nil
    local last_bgb = nil
    local last_l = nil
    for i, o in ipairs(tags) do
        local cache = data[o]
        local tb, bgb, l
        if cache then
            tb = cache.tb
            bgb = cache.bgb
            l = cache.l
        else
            tb = wibox.widget.textbox()
            tb:set_ellipsize('none')
            bgb = wibox.widget.background()
            l = wibox.layout.constraint(tb, 'exact', arrow.width(7), arrow.height())

            bgb:set_widget(l)

            bgb:buttons(widget_common.create_buttons(buttons, o))

            data[o] = {
                tb = tb,
                bgb = bgb,
                l = l
            }
        end
        
        local text, color = label(o)
        if color == nil then
            color = beautiful.bg_normal
        end
        if not pcall(tb.set_markup, tb, text) then
            tb:set_markup("<i>&lt;Invalid text&gt;</i>")
        end
        bgb:set_bg(color)
        w:add(bgb)

        if last_bgb then
            last_bgb:set_bgimage(arrow.make_image(last_color, color, false, 7, false))
        else
            -- This is the first tag, its color defines the left-side arrow color
            w.color_left = color
        end
        last_color = color
        last_bgb = bgb
        last_l = l
    end

    last_l:set_strategy('max')
    w.color_right = last_color
    -- we update once before the object finishes constructing
    if w.refresh_outer_arrows then
        w:refresh_outer_arrows()
    end
end

local function new(screen, filter, buttons, style)
    local function update_func(w, b, l, d, o) return my_update(w, b, l, d, o, style) end
    local ret = awful.widget.taglist(screen, filter, buttons, style, update_func)

    for k, v in pairs(taglist) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    return ret
end

function taglist.mt:__call(...)
    return new(...)
end

return setmetatable(taglist, taglist.mt)
