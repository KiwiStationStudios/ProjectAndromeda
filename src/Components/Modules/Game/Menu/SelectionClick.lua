local SelectionClick = {}
SelectionClick.__index = SelectionClick

local function _new(_x, _y, _w, _h)
    local self = setmetatable({}, SelectionClick)
    self.x = _x
    self.y = _y
    self.w = _w
    self.h = _h
    return self
end

function SelectionClick:hovered()
    local mx, my = love.mouse.getPosition()
    if mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h then
        return true
    end
    return false
end

function SelectionClick:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return setmetatable(SelectionClick, { __call = function(_, ...) return _new(...) end })