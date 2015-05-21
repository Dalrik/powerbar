local wibox = require("wibox")
local arrow = require("powerbar.arrow")

local fixed = { mt = {} }

function fixed:set_arrow_right(arr)
    self.arr_right = arr
    if self.rightmost then
        self.rightmost:set_arrow_right(arr)
    end
end

function fixed:set_arrow_left(arr)
    self.arr_left = arr
    if self.leftmost then
        self.leftmost:set_arrow_left(arr)
    end
end

function fixed:add(segment)
    if self.leftmost then
        local arr = arrow(self.isLeft)
        self.rightmost:set_arrow_right(arr)
        segment:set_arrow_left(arr)
        if self.arr_right then
            segment:set_arrow_right(self.arr_right)
        end
        wibox.layout.fixed.add(self, arr)
        self.rightmost = segment
    else
        if self.arr_right then
            segment:set_arrow_right(self.arr_right)
        end
        if self.arr_left then
            segment.set_arrow_left(self.arr_left)
        end
        self.leftmost = segment
        self.rightmost = segment
    end

    wibox.layout.fixed.add(self, segment)
end

local function new(isLeft)
    local ret = wibox.layout.fixed.horizontal()

    for k, v in pairs(fixed) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret.isLeft = isLeft
    ret.leftmost = nil
    ret.rightmost = nil
    ret.arr_left = nil
    ret.arr_right = nil

    return ret
end

function fixed.mt:__call(...)
    return new(...)
end

return setmetatable(fixed, fixed.mt)
