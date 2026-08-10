---@class Clouds : Event
local Clouds, super = Class(Event)

function Clouds:init(x, y, shape)
    super.init(self, x, y, shape)
    self.x_moved = 0


    self.sprite = Sprite("tilesets/sunrise_back_clouds_fore")
    self:addChild(self.sprite)
    self:setScale(2)
end

function Clouds:update()
    if Game:getFlag("move_Clouds", true) then
        self.x_moved = self.x_moved + 1
        self.x = self.x - 1
        if self.x_moved >= 1120 then
            self.x = 0
            self.x_moved = 0
        end
    end
end

return Clouds
