local wibox = require("wibox")
local vicious = require("vicious")
local segment = require("powerbar.segment")
local beautiful = require("beautiful")

local bat = { mt = {} }

local function lerp(none, full, ratio)
    local range = full - none
    return none + range*ratio
end

local function HSVtoRGB(h, s, v)
    local r, g, b

    local i = math.floor(h*6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    r, g, b = math.floor(r*255), math.floor(g*255), math.floor(b*255)

    return string.format("#%02x%02x%02x", r, g, b)
end

local function bat_update(w, data)
    local charge = tonumber(data[2])/100
    local hval = lerp(0, .3333, charge)
    local bgcolor = HSVtoRGB(hval, .4, .7)
    local fgcolor = beautiful.fg_focus

    if string.find(data[3], "-") or data[3] == "N/A" then
        data[3] = " "
    end

    format = '<span font="Source Code Pro Semibold 12" rise="50" color="' .. fgcolor .. '">' .. data[1] .. data[2] .. '%<span font="Source Code Pro Semibold 8" rise="0">' .. data[3] .. '</span></span>'

    w.seg:set_color(bgcolor)
    return format
end

local function new(battery)
    local tbox = wibox.widget.textbox()
    local seg = segment(tbox)
    vicious.register(tbox, vicious.widgets.bat, bat_update, nil, battery)
    return seg
end

function bat.mt:__call(...)
    return new(...)
end

return setmetatable(bat, bat.mt)
