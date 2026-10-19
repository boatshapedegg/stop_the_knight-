local SmallBullet, super = Class(ParryableBullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/star")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self:setScale(1)

    self.destroy_on_parry = false

    self.destroy_on_hit = false

    self:setHitbox(23,21,17,17)

    self.parry_dist = 40
end

function SmallBullet:onParry()
    self:setColor(1,0,0)
    Assets.playSound("damage")
    self.physics.speed = self.physics.speed * 0.6
    Game.battle.timer:after(0.1, function ()
        self:fadeOutAndRemove(0.25)
    end)
end


function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return SmallBullet
