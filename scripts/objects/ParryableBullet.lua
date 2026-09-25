---@class ParryableBullet : Bullet
---@overload fun(...) : ParryableBullet
local ParryableBullet, super = Class(Bullet)

function ParryableBullet:init(x, y, texture)
    super.init(self, x, y, texture)

    self.destroy_on_parry = true

    self.can_graze = false
end

function ParryableBullet:update()
    super.update(self)
    local kris = Game.battle:getPartyBattler("kris")
    local kx, ky = kris:getRelativePos(kris.width/2, kris.height/2)
    if kris.parrying and MathUtils.dist(self.x, self.y, kx, ky) <= 25 then
        if self.destroy_on_parry then self:remove() end
        Game:setTension(Game.tension + 5)
        self:onParry()
    end
end

function ParryableBullet:onParry() end

return ParryableBullet