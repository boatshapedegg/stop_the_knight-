local SmallBullet, super = Class(ParryableBullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/smallbullet")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self.destroy_on_parry = true
end

--[[function SmallBullet:onCollide(soul)
    if Game.battle:getPartyBattler("kris").parrying then
        if self.destroy_on_parry then self:remove() end
        Game:setTension(Game.tension + 5)
        self:onParry()
    else
        super.onCollide(self, soul)
    end
end

function SmallBullet:onParry() end]]--


function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return SmallBullet
