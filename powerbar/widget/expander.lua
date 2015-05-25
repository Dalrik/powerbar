local base = require("wibox.widget.base")

-- wibox.widget.textbox
local expander = { mt = {} }

--- No-op, accept whatever background is drawn
function expander:draw(wibox, cr, width, height)
end

--- Fill to all available space
function expander:fit(width, height)
    return width, height
end

local function new()
    local ret = base.make_widget()

    for k, v in pairs(expander) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    return ret
end

function expander.mt:__call(...)
    return new(...)
end

return setmetatable(expander, expander.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
