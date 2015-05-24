local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local cairo = require("lgi").cairo
local beautiful = require("beautiful")

local arrow = { mt = {} }

local arrow_cache = setmetatable({}, { __mode = 'v' })

function arrow.make_image(color_l, color_r, isLeft, exWidth)
    exWidth = exWidth or 0
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
            altTemplate = gears.surface.load(beautiful.arrAltTemplate)
            cr:set_source_surface(altTemplate, 0, 0)
            cr:paint()
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
    self:set_image(arrow.make_image(self.color_left, self.color_right, self.isLeft))
end

function arrow:set_color_left(color)
    if self.color_left ~= color then
        self.color_left = color
        self:refresh_image()
    end
end

function arrow:set_color_right(color)
    if self.color_right ~= color then
        self.color_right = color
        self:refresh_image()
    end
end

local function new(isLeft)
    local ret = wibox.widget.imagebox(nil, false)

    for k, v in pairs(arrow) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret.isLeft = isLeft
    ret.color_left = beautiful.bg_normal
    ret.color_right = beautiful.bg_normal
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
