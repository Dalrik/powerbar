local wibox = require("wibox")
local util  = require("awful.util")
local arrow = require("powerbar.arrow")

local fixed = { mt = {} }

function fixed:set_arrow_right(arr)
    self._private.arr_right = arr
    if self._private.rightmost then
        self._private.rightmost.arrow_right = arr
    end
end

function fixed:set_arrow_left(arr)
    self._private.arr_left = arr
    if self._private.leftmost then
        self._private.leftmost.arrow_left = arr
    end
end

function fixed:add(segment)
    if self._private.leftmost then
        local arr = arrow(self._private.isLeft)
        self._private.rightmost.arrow_right = arr
        segment.arrow_left = arr
        if self._private.arr_right then
            segment.arrow_right = self._private.arr_right
        end
        wibox.layout.fixed.add(self, arr)
        self._private.rightmost = segment
    else
        if self._private.arr_right then
            segment.arrow_right = self._private.arr_right
        end
        if self._private.arr_left then
            segment.arrow_left = self._private.arr_left
        end
        self._private.leftmost = segment
        self._private.rightmost = segment
    end

    wibox.layout.fixed.add(self, segment)
end

local function new(isLeft)
    local ret = wibox.layout.fixed.horizontal()

    util.table.crush(ret, fixed, true)

    ret._private.isLeft = isLeft
    ret._private.leftmost = nil
    ret._private.rightmost = nil
    ret._private.arr_left = nil
    ret._private.arr_right = nil

    return ret
end

function fixed.left_arrow()
    return new(true)
end

function fixed.right_arrow()
    return new(false)
end

function fixed.mt:__call(...)
    return new(...)
end

return setmetatable(fixed, fixed.mt)
