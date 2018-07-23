local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local util  = require("awful.util")
local cairo = require("lgi").cairo
local beautiful = require("beautiful")

local arrow = { mt = {} }

local arrow_cache = setmetatable({}, { __mode = 'v' })

function arrow.width(exWidth)
    exWidth = exWidth or 0
    local w, h = gears.surface.get_size(gears.surface.load(beautiful.arrTemplate))
    return w + exWidth
end

function arrow.height()
    local w, h = gears.surface.get_size(gears.surface.load(beautiful.arrTemplate))
    return h
end

function arrow.make_image(color_l, color_r, isLeft, exWidth, drawSeparator)
    exWidth = exWidth or 0
    if drawSeparator == nil then
        drawSeparator = true
    end
    color_l = color_l or beautiful.bg_systray
    color_r = color_r or beautiful.bg_systray
    local cache_str = color_l .. color_r .. exWidth
    if isLeft then
        cache_str = "L" .. cache_str
    else
        cache_str = "R" .. cache_str
    end

    local cached = arrow_cache[cache_str]
    local img
    if cached then
        img = cached
    else
        local pat_l = gears.color(color_l)
        local pat_r = gears.color(color_r)
        local template = gears.surface.load(beautiful.arrTemplate)
        local tw, h = gears.surface.get_size(template)
        local w = tw + exWidth
        img = cairo.ImageSurface(cairo.Format.RGBA32, w, h)
        local cr = cairo.Context(img)

        -- Adjust transformation matrix if rendering a right arrow
        if not isLeft then
            cr:rotate(math.pi)
            cr:translate(-w, -h)
            pat_l, pat_r = pat_r, pat_l
        end

        -- Draw "non-arrow" background
        cr:set_source(pat_l)
        cr:paint()

        if color_l == color_r then
            if drawSeparator then
                altTemplate = gears.surface.load(beautiful.arrAltTemplate)
                cr:set_source_surface(altTemplate, 0, 0)
                cr:paint()
            end
        else
            cr:set_source(pat_r)
            cr:mask_surface(template, 0, 0)
        end

        if exWidth ~= 0 then
            cr:rectangle(tw, 0, exWidth, h)
            cr:clip()
            cr:set_source(pat_r)
            cr:paint()
        end
        arrow_cache[cache_str] = img
    end

    return img
end

function arrow:refresh_image()
    self.image = arrow.make_image(self._private.color_left, self._private.color_right, self._private.isLeft)
end

function arrow:set_color_left(color)
    if self._private.color_left ~= color then
        self._private.color_left = color
        self:refresh_image()
    end
end

function arrow:set_color_right(color)
    if self._private.color_right ~= color then
        self._private.color_right = color
        self:refresh_image()
    end
end

local function new(isLeft)
    local ret = wibox.widget.imagebox(nil, false)

    util.table.crush(ret, arrow, true)

    ret._private.isLeft = isLeft
    ret._private.color_left = nil
    ret._private.color_right = nil
    ret:refresh_image()

    return ret
end

function arrow.left()
    return new(true)
end

function arrow.right()
    return new(false)
end

function arrow.mt:__call(...)
    return new(...)
end

return setmetatable(arrow, arrow.mt)
