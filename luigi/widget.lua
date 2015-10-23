local ROOT = (...):gsub('[^.]*$', '')

local Base = require(ROOT .. 'base')
local Event = require(ROOT .. 'event')

local Widget = Base:extend()

Widget.isWidget = true

Widget.registeredTypes = {
    sash = ROOT .. 'widget.sash',
    slider = ROOT .. 'widget.slider',
    text = ROOT .. 'widget.text',
}

function Widget.create (layout, data)
    local path = data.type and Widget.registeredTypes[data.type]

    if path then
        return require(path)(layout, data)
    end

    return Widget(layout, data)
end

function Widget:constructor (layout, data)
    self.type = 'generic'
    self.layout = layout
    self.children = {}
    self.position = { x = nil, y = nil }
    self.dimensions = { width = nil, height = nil }
    self:extract(data)
    layout:addWidget(self)
    local widget = self
    local meta = getmetatable(self)
    local metaIndex = meta.__index
    function meta:__index(property)
        local value = metaIndex[property]
        local style = widget.layout.style
        local theme = widget.layout.theme
        if value ~= nil then return value end
        value = style and style:getProperty(self, property)
        if value ~= nil then return value end
        return theme and theme:getProperty(self, property)
    end
end

function Widget:extract (data)
    function toWidget(t)
        if t.isWidget then return t end
        return Widget.create(self.layout, t)
    end

    for k, v in pairs(data) do
        if type(k) == 'number' then
            self.children[k] = toWidget(v)
            self.children[k].parent = self
        else
            self[k] = v
        end
    end
end

function Widget:getPrevious ()
    local siblings = self.parent.children
    for i, widget in ipairs(siblings) do
        if widget == self then return siblings[i - 1] end
    end
end

function Widget:getNext ()
    local siblings = self.parent.children
    for i, widget in ipairs(siblings) do
        if widget == self then return siblings[i + 1] end
    end
end

function Widget:addChild (data)
    local layout = self.layout
    local child = Widget.create(layout, data)

    table.insert(self.children, child)
    child.parent = self
    layout:addWidget(child)
end

function Widget:calculateDimension (name)
    function clamp(value, min, max)
        if value < min then
            value = min
        elseif value > max then
            value = max
        end
        return value
    end
    if self[name] then
        self.dimensions[name] = clamp(self[name], 0, self.layout.root[name])
    end
    if self.dimensions[name] then
        return self.dimensions[name]
    end
    local parent = self.parent
    if not parent then
        return self.layout
    end
    local parentDimension = parent:calculateDimension(name)
    local parentFlow = parent.flow or 'y'
    if (parentFlow == 'y' and name == 'width') or
        (parentFlow == 'x' and name == 'height')
    then
        return parentDimension
    end
    local claimed = 0
    local unsized = 1
    for i, widget in ipairs(self.parent.children) do
        if widget ~= self then
            if widget[name] then
                claimed = claimed + widget:calculateDimension(name)
                if claimed > parentDimension then
                    claimed = parentDimension
                end
            else
                unsized = unsized + 1
            end
        end
    end
    local size = (self.parent:calculateDimension(name) - claimed) / unsized
    self.dimensions[name] = clamp(size, 0, self.layout.root[name])
    return size
end

function Widget:calculatePosition (axis)
    if self.position[axis] then
        return self.position[axis]
    end
    local parent = self.parent
    if not parent then
        self.position[axis] = 0
        return 0
    end
    local parentPos = parent:calculatePosition(axis)
    local p = parentPos
    local parentFlow = parent.flow or 'y'
    for i, widget in ipairs(parent.children) do
        if widget == self then
            self.position[axis] = p
            return p
        end
        if parentFlow == axis then
            local dimension = (axis == 'x') and 'width' or 'height'
            p = p + widget:calculateDimension(dimension)
        end
    end
    self.position[axis] = 0
    return 0
end

function Widget:getX ()
    return self:calculatePosition('x')
end

function Widget:getY ()
    return self:calculatePosition('y')
end

function Widget:getWidth ()
    return self:calculateDimension('width')
end

function Widget:getHeight ()
    return self:calculateDimension('height')
end

function Widget:setDimension (name, size)
    local parentDimension = self.parent:calculateDimension(name)
    local claimed = 0
    for i, widget in ipairs(self.parent.children) do
        if widget ~= self and widget[name] then
            claimed = claimed + widget[name]
        end
    end
    if claimed + size > parentDimension then
        size = parentDimension - claimed
    end
    self[name] = size
end

function Widget:setWidth (size)
    return self:setDimension('width', size)
end

function Widget:setHeight (size)
    return self:setDimension('height', size)
end

function Widget:getOrigin ()
    return self:getX(), self:getY()
end

function Widget:getExtent ()
    local x, y = self:getX(), self:getY()
    return x + self:getWidth(), y + self:getHeight()
end

function Widget:getRectangle (useMargin, usePadding)
    local x1, y1 = self:getOrigin()
    local x2, y2 = self:getExtent()
    local function shrink(amount)
        x1 = x1 + amount
        y1 = y1 + amount
        x2 = x2 - amount
        y2 = y2 - amount
    end
    if useMargin then
        shrink(self.margin or 0)
    end
    if usePadding then
        shrink(self.padding or 0)
    end
    return x1, y1, x2, y2
end

function Widget:isAt (x, y)
    local x1, y1, x2, y2 = self:getRectangle()
    return (x1 < x) and (x2 > x) and (y1 < y) and (y2 > y)
end

function Widget:getAncestors (includeSelf)
    local instance = includeSelf and self or self.parent
    return function()
        local widget = instance
        if not widget then return end
        instance = widget.parent
        return widget
    end
end

function Widget:update ()
    self.layout:update()
end

-- event binders

Event.injectBinders(Widget)

return Widget