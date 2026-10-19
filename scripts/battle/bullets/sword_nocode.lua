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

    if flash == true then Game.battle.timer:tween(flashtime, self, {color = {1,0,0}}) end
end

function SmallBullet:shouldSwoon(damage, target, soul)
    return true
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)
end

function SmallBullet:zip()
    local grower = Game.battle:addChild(Sprite(self.sprite:getTexture(), self.x, self.y))
    grower.alpha = 0.5
    grower.rotation = self.rotation
    grower:setOrigin(0.5)
    grower:fadeOutAndRemove(DT*2)
    grower.layer = self.layer - 1
    grower:setColor(COLORS.red)
    Game.battle.timer:tween(DT*2, grower, {scale_x = 2, scale_y = 2})
    Assets.playSound("knight_jump_quick", 1.5, 1.25)
    local af = self.sprite:addFX(ColorMaskFX({1,1,1}, 1), "color")
    Game.battle.timer:after(0.1, function ()
        self.alpha = 0
        af.amount = 0
        Assets.playSound("knight_cut2", 1.5, 1.25)
        for i = 0, 34 do
            local x = self.x + 20*i * math.cos(self.rotation)
            local y = self.y + 20*i * math.sin(self.rotation)
            local afterimage = Game.battle:addChild(Sprite(self.sprite:getTexture(), x, y))
            afterimage.layer = self.layer
            afterimage:setColor(COLORS.red)
            afterimage.rotation = self.rotation
            afterimage:setOrigin(0.5)
            afterimage.alpha = 0.3 + (0.01*i)
            afterimage:fadeOutAndRemove(DT*3)
            afterimage.debug_select = false
        end
        Game.battle.timer:after(DT, function()
            local rect = Game.battle:addChild(Rectangle(self.x - 1, self.y, 800, 2))
            rect.rotation = self.rotation
            self:setHitbox(0, 14, 800, 2)
            rect.layer = BATTLE_LAYERS["above_bullets"]
            --rect:addFX(MaskFX(Game.battle.arena))
            Game.battle.timer:after(DT * 3, function()
                rect:remove()
            end)
        end)

        Game.battle.timer:after(DT*4, function()
            self:remove()
        end)
    end)
end

return SmallBullet
