local Basic, super = Class(FullScreenWave)

function Basic:init()
    super.init(self)

    self.time = 9
end

function Basic:onStart()
    super.onStart(self)
    self.knight_slide = false
    
    local knight = Game.battle:getEnemyBattler("knight")
    knight:setFlag("hover", false)
    knight:setSprite("attack1_2")
    self.timer:after(0.5, function()
        local mask = knight:addFX(ColorMaskFX({1, 1, 1}, 0), "mask")
        self.timer:tween(0.9, mask, {amount = 1}, "in-cubic")
        self.timer:after(1, function()
            knight:setAnimation("attack2")
            knight:removeFX("mask")
            local hitbox = self:spawnBullet("parrybullet", knight.x - 80, knight.y - 100)
            hitbox.alpha = 0
            hitbox:setHitbox(0,0,40,70)

            function hitbox:onParry()
                Assets.playSound("damage")
            end
        end)

        self.timer:after(0.4, function()
            knight:slideTo(Game.battle.soul.x + 90, knight.y - 10, 0.6, "out-cubic", function() self.knight_slide = true end)
        end)
    end)

    self.timer:after(2.5, function()
        local mask = knight:addFX(ColorMaskFX({1, 1, 1}, 0), "mask")
        self.timer:tween(0.7, mask, {amount = 1}, "in-cubic")
        self.timer:after(0.8, function()
            knight:setAnimation("attack1")
            knight:removeFX("mask")
            local hitbox = self:spawnBullet("parrybullet", knight.x - 80, knight.y - 100)
            hitbox.alpha = 0
            hitbox:setHitbox(0,0,40,70)

            function hitbox:onParry()
                self.knight_slide = false
                Assets.playSound("damage")
                knight:slideTo(550, 200, 0.5, "out-quad")
                for i = 1, 5 do
                    local sword = self.wave:spawnBullet("sword_nocode", 640, 50 + i*50, Utils.angle(640, 50 + i*50, Game.battle.soul.x, Game.battle.soul.y), 30)
                end
            end

            function hitbox:onCollide()
                super.onCollide(hitbox)
                Game.battle.timer:after(0.5, function()
                    self.knight_slide = false
                    knight:slideTo(550, 200, 0.75, "out-quad")
                end)
            end
        end)
    end)
end

function Basic:update()
    -- Code here gets called every frame

    if self.knight_slide then
        Game.battle:getEnemyBattler("knight").x = Game.battle.soul.x + 90
    end

    super.update(self)
end

return Basic
