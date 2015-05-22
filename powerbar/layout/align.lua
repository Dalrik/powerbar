local wibox = require("wibox")
local arrow = require("powerbar.arrow")
local beautiful = require("beautiful")

local align = { mt = {} }

function align:set_arrow_right(arr)
    self.arr_right = arr
    if self.right then
        self:refresh_layout()
    else
        arr:set_color_left(beautiful.bg_normal)
    end
end

function align:set_arrow_left(arr)
    self.arr_left = arr
    if self.left then
        self:refresh_layout()
    else
        arr:set_color_right(beautiful.bg_normal)
    end
end

function align:refresh_layout()
    local arr_lm = arrow(false)
    local arr_mr = arrow(true)
    local box_l = wibox.layout.fixed.horizontal()
    local box_r = wibox.layout.fixed.horizontal()

    if self.left then
        self.left:set_arrow_left(self.arr_left)
        self.left:set_arrow_right(arr_lm)
        box_l:add(self.left)
    end
    box_l:add(arr_lm)
    if self.middle then
        self.middle:set_arrow_left(arr_lm)
        self.middle:set_arrow_right(arr_mr)
    end
    box_r:add(arr_mr)
    if self.right then
        self.right:set_arrow_left(arr_mr)
        self.right:set_arrow_right(self.arr_right)
        box_r:add(self.right)
    end

    wibox.layout.align.set_first(self, box_l)
    wibox.layout.align.set_second(self, self.middle)
    wibox.layout.align.set_third(self, box_r)
end

function align:set_left(segment)
    self.left = segment
    self:refresh_layout()
end

function align:set_middle(segment)
    self.middle = segment
    self:refresh_layout()
end

function align:set_right(segment)
    self.right = segment
    self:refresh_layout()
end

local function new()
    local ret = wibox.layout.align.horizontal()

    for k, v in pairs(align) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret.left = nil
    ret.right = nil
    ret.middle = nil
    ret.arr_left = nil
    ret.arr_right = nil

    return ret
end

function align.mt:__call(...)
    return new(...)
end

return setmetatable(align, align.mt)
