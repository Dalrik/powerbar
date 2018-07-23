local wibox = require("wibox")
local util  = require("awful.util")
local arrow = require("powerbar.arrow")
local beautiful = require("beautiful")

local align = { mt = {} }

function align:set_arrow_right(arr)
    self._private.arr_right = arr
    if self._private.right then
        self:refresh_layout()
    else
        arr.color_left = beautiful.bg_normal
    end
end

function align:set_arrow_left(arr)
    self._private.arr_left = arr
    if self._private.left then
        self:refresh_layout()
    else
        arr.color_right = beautiful.bg_normal
    end
end

function align:refresh_layout()
    local arr_lm = arrow.right()
    local arr_mr = arrow.left()
    local box_l = wibox.layout.fixed.horizontal()
    local box_r = wibox.layout.fixed.horizontal()

    if self._private.left then
        self._private.left.arrow_left  = self._private.arr_left
        self._private.left.arrow_right = arr_lm
        box_l:add(self._private.left)
    end
    box_l:add(arr_lm)
    if self._private.middle then
        self._private.middle.arrow_left  = arr_lm
        self._private.middle.arrow_right = arr_mr
    end
    box_r:add(arr_mr)
    if self._private.right then
        self._private.right.arrow_left  = arr_mr
        self._private.right.arrow_right = arr_right
        box_r:add(self._private.right)
    end

    wibox.layout.align.set_first(self, box_l)
    wibox.layout.align.set_second(self, self._private.middle)
    wibox.layout.align.set_third(self, box_r)
end

function align:set_left(segment)
    self._private.left = segment
    self:refresh_layout()
end

function align:set_middle(segment)
    self._private.middle = segment
    self:refresh_layout()
end

function align:set_right(segment)
    self._private.right = segment
    self:refresh_layout()
end

local function new()
    local ret = wibox.layout.align.horizontal()

    util.table.crush(ret, align, true)

    ret._private.left = nil
    ret._private.right = nil
    ret._private.middle = nil
    ret._private.arr_left = nil
    ret._private.arr_right = nil

    return ret
end

function align.mt:__call(...)
    return new(...)
end

return setmetatable(align, align.mt)
