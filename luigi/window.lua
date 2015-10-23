local ROOT = (...):gsub('[^.]*$', '')

local Base = require(ROOT .. 'base')
local Hooker = require(ROOT .. 'hooker')

local Window = Base:extend()

local unpack = table.unpack or _G.unpack

function Window:constructor (input)
    self.input = input
    self.isMousePressed = false
    self.isManagingInput = false
    self.hooked = {}
    self.hooks = {}
end

function Window:hook (key, method)
    self.hooks[#self.hooks + 1] = Hooker.hook(key, method)
end

function Window:unhook ()
    for _, item in ipairs(self.hooks) do
        Hooker.unhook(item)
    end
    self.hooks = {}
end

function Window:manageInput (input)
    if self.isManagingInput then
        return
    end
    self.isManagingInput = true

    self:hook('draw', function ()
        input:handleDisplay()
    end)
    self:hook('resize', function (width, height)
        return input:handleReshape(width, height)
    end)
    self:hook('mousepressed', function (x, y, button)
        self.isMousePressed = true
        return input:handlePressStart(button, x, y)
    end)
    self:hook('mousereleased', function (x, y, button)
        self.isMousePressed = false
        return input:handlePressEnd(button, x, y)
    end)
    self:hook('mousemoved', function (x, y, dx, dy)
        if self.isMousePressed then
            return input:handlePressedMotion(x, y)
        else
            return input:handleMotion(x, y)
        end
    end)
    self:hook('keypressed', function (key, isRepeat)
        return input:handleKeyboard(key, love.mouse.getX(), love.mouse.getY())
    end)
end

function Window:show (width, height, title)
    local currentWidth, currentHeight, flags = love.window.getMode()
    love.window.setMode(width or currentWidth, height or currentHeight, flags)
    if title then
        love.window.setTitle(title)
    end
    self:manageInput(self.input)
end

function Window:hide ()
    if not self.isManagingInput then
        return
    end
    self.isManagingInput = false
    self:unhook()
end

function Window:fill (x1, y1, x2, y2, color)
    love.graphics.push('all')
    love.graphics.setColor(color)
    love.graphics.rectangle('fill', x1, y1, x2 - x1, y2 - y1)
    love.graphics.pop()
end

function Window:outline (x1, y1, x2, y2, color)
    love.graphics.push('all')
    love.graphics.setColor(color)
    love.graphics.rectangle('line', x1, y1, x2 - x1, y2 - y1)
    love.graphics.pop()
end

function Window:write (x, y, x1, y1, x2, y2, text, font)
    local layout = font.layout

    love.graphics.push('all')
    love.graphics.setFont(font.font)
    love.graphics.setColor(font.color)
    love.graphics.printf(text, x, y, layout.width or x2 - x1, layout.align)
    love.graphics.pop()
end

function Window:update (reshape)
    if reshape then
        for i, widget in ipairs(self.input.layout.widgets) do
            widget.position = {}
            widget.dimensions = {}
            widget.fontData = nil
        end
    end
end

return Window