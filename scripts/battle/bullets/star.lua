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
end

function SmallBullet:onParry()
    self:setColor(1,0,0)
    Game.battle.timer:after(0.5, function ()
        self:fadeOutAndRemove(0.25)
    end)
end


function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return SmallBullet
