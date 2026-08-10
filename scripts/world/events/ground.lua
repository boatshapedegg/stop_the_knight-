---@class Ground : Event
local Ground, super = Class(Event)

function Ground:init(x, y, shape)
    super.init(self, x, y, shape)
    self.x_moved = 0


    self.sprite = Sprite("tilesets/floor")
    self:addChild(self.sprite)
    self:setScale(2)
end

function Ground:update()
    if Game:getFlag("move_ground", true) then
        self.x_moved = self.x_moved + 8
        self.x = self.x - 8
        if self.x_moved >= 640 then
            self.x = 0
            self.x_moved = 0
        end
    end
end

return Ground
