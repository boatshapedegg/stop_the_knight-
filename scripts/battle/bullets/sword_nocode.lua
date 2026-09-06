---@class SmallBullet : Bullet
local SmallBullet, super = Class(Bullet)

---@param x number # The X position of the bullet
---@param y number # The Y position of the bullet
---@param dir number # The dir (in radians) of the bullet
---@param speed number # The speed the bullet will move at in the specified direction
function SmallBullet:init(x, y, dir, speed, flash, flashtime)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/knight_sword")

    self:setScale(1)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.rotation = dir

    self.physics.match_rotation = true

    self.destroy_on_hit = false

    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    --if flash == true then Game.battle.timer:after(flashtime - 0.25, function()
        Assets.playSound("knight_jump_quick", 1.5, 1.25)
    --end) end
    if flash == true then Game.battle.timer:after(flashtime, function()
        Assets.playSound("knight_cut2", 1.5, 1.25)
    end) end
    if flash == true then Game.battle.timer:tween(flashtime, self, {color = {1,0,0}}) end
end

function SmallBullet:shouldSwoon(damage, target, soul)
    return true
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

return SmallBullet
