local SmallBullet, super = Class(ParryableBullet)

function SmallBullet:init(relative_x, relative_y, char, hitbox)
    -- Last argument = sprite path
    super.init(self, char.x + relative_x, char.y + relative_y, "bullets/smallbullet")

    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = 0

    self.alpha = 0

    local x1, y1, x2, y2 = unpack(hitbox)
    self:setHitbox(x1, y1, x2, y2)

    self.destroy_on_parry = true

    self.char = char
    self.rel_x = relative_x
    self.rel_y = relative_y
end


function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)

    self.x = self.char.x + self.rel_x
    self.y = self.char.y + self.rel_y
end

return SmallBullet
