local SelectionClick = {}
SelectionClick.__index = SelectionClick

local function _new(_x, _y, _w, _h)
    local self = setmetatable({}, SelectionClick)
    self.x = _x
    self.y = _y
    self.w = _w
    self.h = _h
    self.mx = 0
    self.my = 0
    return self
end

function SelectionClick:hovered()
    if self.mx >= self.x and self.mx <= self.x + self.w and self.my >= self.y and self.my <= self.y + self.h then
        return true
    end
    return false
end

function SelectionClick:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return setmetatable(SelectionClick, { __call = function(_, ...) return _new(...) end })