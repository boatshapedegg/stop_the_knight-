---@class ParryableBullet : Bullet
---@overload fun(...) : ParryableBullet
local ParryableBullet, super = Class(Bullet)

function ParryableBullet:init(x, y, texture)
    super.init(self, x, y, texture)

    self.destroy_on_parry = true
end

function ParryableBullet:onCollide(soul)
    if Game.battle:getPartyBattler("kris").parrying then
        if self.destroy_on_parry then self:remove() end
        Game:setTension(Game.tension + 5)
        self:onParry()
    else
        super.onCollide(self, soul)
    end
end

function ParryableBullet:onParry() end

return ParryableBullet