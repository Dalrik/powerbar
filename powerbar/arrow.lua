local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local cairo = require("lgi").cairo

local arrow = { mt = {} }

local arrow_cache = setmetatable({}, { __mode = 'v' })

function arrow:refresh_image()
    local cache_str = self.color_left .. self.color_right
    if self.isLeft then
        cache_str = "L" .. cache_str
    else
        cache_str = "R" .. cache_str
    end

    local cached = arrow_cache[cache_str]
    local img
    if cached then
        img = cached
    else
        local rl, bl, gl = gears.color.parse_color(self.color_left)
        local rr, br, gr = gears.color.parse_color(self.color_right)
        local template = gears.surface.load(beautiful.arrTemplate)
        local w, h = gears.surface.get_size(template)
        img = cairo.ImageSurface(cairo.Format.RGBA32, w, h)
        local cr = cairo.Context(img)

        -- Adjust transformation matrix if rendering a right arrow
        if not self.isLeft then
            cr:rotate(math.pi)
            cr:translate(-w, -h)
            local rt, bt, gt = rl, bl, gl
            rl, bl, gl = rr, br, gr
            rr, br, gr = rt, bt, gt
        end

        -- Draw "non-arrow" background
        cr:set_source_rgb(rl,bl,gl)
        cr:paint()

        if self.color_left == self.color_right then
            altTemplate = gears.surface.load(beautiful.arrAltTemplate)
            cr:set_source_surface(altTemplate, 0, 0)
            cr:paint()
        else
            cr:set_source_rgb(rr,br,gr)
            cr:mask_surface(template, 0, 0)
        end
        arrow_cache[cache_str] = img
    end
    
    self:set_image(img)
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
    ret.color_left = "#000000"
    ret.color_right = "#000000"
    ret:refresh_image()

    return ret
end

function arrow.mt:__call(...)
    return new(...)
end

return setmetatable(arrow, arrow.mt)
