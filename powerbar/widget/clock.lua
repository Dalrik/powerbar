local wibox = require("wibox")
local vicious = require("vicious")
local segment = require("powerbar.segment")
local beautiful = require("beautiful")

local clock = { mt = {} }

local function new(template, rate, fg_color, bg_color, font)
    fg_color = fg_color or beautiful.fg_clock or beautiful.fg_normal
    bg_color = bg_color or beautiful.bg_clock or beautiful.bg_normal
    font = font or beautiful.font
    local strf = '<span font="' .. font .. '" rise="50" color="' .. fg_color .. '" background="' .. bg_color .. '">' .. template .. '</span>'
    local tbox = wibox.widget.textbox()
    local seg = segment(tbox, bg_color)
    vicious.register(tbox, vicious.widgets.date, strf, rate)
    return seg
end

function clock.mt:__call(...)
    return new(...)
end

return setmetatable(clock, clock.mt)
