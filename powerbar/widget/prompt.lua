local textbox = require("wibox.widget.textbox")
local widget_base = require("wibox.widget.base")
local prompt = require("awful.prompt")
local completion = require("awful.completion")
local util = require("awful.util")
local segment = require("powerbar.segment")
local beautiful = require("beautiful")

local widgetprompt = { mt = {} }

--- Run method for promptbox.
-- @param promptbox The promptbox to run.
local function run(promptbox)
    return prompt.run({ prompt = promptbox.prompt },
                      promptbox.widget,
                      function (...)
                          local result = util.spawn(...)
                          if type(result) == "string" then
                              promptbox.widget:set_markup(result)
                          end
                      end,
                      completion.shell,
                      util.getdir("cache") .. "/history")
end

--- Create a prompt widget which will launch a command.
-- @param args Arguments table. "prompt" is the prompt to use.
-- @return A launcher widget.
local function new(args, color)
    local args = args or {}
    local fg_color = beautiful.fg_prompt or beautiful.fg_normal
    local bg_color = color or beautiful.bg_prompt or beautiful.bg_normal
    local widget = textbox()

    -- Hack to modify foreground color of run prompt
    local tbox_set_markup = widget.set_markup
    local function override_set_markup(w, text)
        text = "<span foreground='" .. util.ensure_pango_color(fg_color, "black") .. "'>" .. text .. "</span>"
        tbox_set_markup(w, text)
    end
    widget.set_markup = override_set_markup

    local promptbox = segment(widget_base.make_widget(widget), bg_color)

    promptbox.widget = widget
    promptbox.widget:set_ellipsize("start")
    promptbox.run = run
    promptbox.prompt = args.prompt or "Run: "
    return promptbox
end

function widgetprompt.mt:__call(...)
    return new(...)
end

return setmetatable(widgetprompt, widgetprompt.mt)
