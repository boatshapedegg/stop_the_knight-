local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/crescent")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.rotation = dir
    self.physics.match_rotation = true
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self.timer = 0

    self.destroy_on_hit = false
end

function SmallBullet:shouldSwoon(damage, target, soul)
    return true
end

function SmallBullet:onAdd()
    local duplicate = Game.battle:addChild(Sprite("bullets/crescent", self.x, self.y))
    duplicate:setScale(2, 2)
    Game.battle.timer:tween(0.3, duplicate, {scale_y = 4})
    duplicate:setScaleOrigin(0.5)
    duplicate:fadeOutAndRemove(0.3)

    Game.battle.timer:after(0.85, function ()
        self.rotation = math.rad(180)
    end)
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)

    if self.timer == 0 then
        self:addChild(AfterImage(self, 0.5, 0.1))
        self.timer = 3
    end
    self.timer = self.timer - 1
end

return SmallBullet
