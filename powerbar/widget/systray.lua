local wibox = require("wibox")
local vicious = require("vicious")
local segment = require("powerbar.segment")
local beautiful = require("beautiful")

local systray = { mt = {} }

local function new(revers)
    local color = beautiful.bg_systray or beautiful.bg_normal or "#000000"
    local seg = segment(wibox.widget.systray(revers), color)
    return seg
end

function systray.mt:__call(...)
    return new(...)
end

return setmetatable(systray, systray.mt)
