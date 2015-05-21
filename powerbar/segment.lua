local widget = require("wibox.widget")
local beautiful = require("beautiful")

local segment = { mt = {} }

function segment:set_arrow_right(arr)
    self.arr_right = arr
    arr:set_color_left(self.color)
end

function segment:set_arrow_left(arr)
    self.arr_left = arr
    arr:set_color_right(self.color)
end

function segment:set_color(color)
    if self.color ~= color then
        if self.arr_left then
            self.arr_left:set_color_right(color)
        end
        if self.arr_right then
            self.arr_right:set_color_left(color)
        end
        self.color = color
        self:set_bg(color)
    end
end

local function new(base, color)
    color = color or beautiful.bg_normal
    local ret = widget.background()
    ret:set_widget(base)
    base.seg = ret

    for k, v in pairs(segment) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret:set_color(color)

    return ret
end

function segment.mt:__call(...)
    return new(...)
end

return setmetatable(segment, segment.mt)
