local container = require("wibox.container")
local util      = require("awful.util")
local beautiful = require("beautiful")

local segment = { mt = {} }

function segment:set_arrow_right(arr)
    self._private.arr_right = arr
    if arr then
        arr.color_left = self._private.color
    end
end

function segment:set_arrow_left(arr)
    self._private.arr_left = arr
    if arr then
        arr.color_right = self._private.color
    end
end

function segment:set_color(color)
    if self._private.color ~= color then
        if self._private.arr_left then
            self._private.arr_left.color_right = color
        end
        if self._private.arr_right then
            self._private.arr_right.color_left = color
        end
        self._private.color = color
        self.bg = color
    end
end

local function new(base, color)
    color = color or beautiful.bg_normal
    local ret = container.background()
    ret.widget = base
    base.seg = ret

    util.table.crush(ret, segment, true)

    ret.color = color

    return ret
end

function segment.mt:__call(...)
    return new(...)
end

return setmetatable(segment, segment.mt)
