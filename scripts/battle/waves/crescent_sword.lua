local Basic, super = Class(FullScreenWave)

function Basic:init()
    super.init(self)

    self.time = 9
end

function Basic:onStart()
    super.onStart(self)
    local knight = self:getAttackers()[1]
    knight:setFlag("hover", false)
    knight:setFlag("afterimage", false)
    local x_bound, y_bound = {knight.x - 30, knight.x}, {knight.y - 150, knight.y + 50}

    self.timer:everyInstant(0.5, function()
        knight.alpha = 1
        local x, y = math.random(x_bound[1], x_bound[2]), math.random(y_bound[1], y_bound[2])
        knight.x = x
        knight.y = y
        if math.random(2) == 1 then
            Assets.playSound("knight_cut2", 1.5, 1.25)
            local offset = math.random(-70, 70)
            knight:setAnimation("crescent")
            local x2, y2 = knight.x, knight.y
            local crescent = self:spawnBullet("crescent", x - 30, y - 25, Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y - 45 + offset), 13)
            local crescent2 = self:spawnBullet("crescent2", x - 30, y + 25, Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y + 45 + offset), 13)
            crescent.physics.friction = -0.15
            crescent2.physics.friction = -0.15
        else
            knight:setAnimation("attack2")

            local x2, y2 = knight.x - 30, knight.y - 55
            local knife = self:spawnBullet("sword_nocode", x2, y2, Utils.angle(x2, y2, Game.battle.soul.x, Game.battle.soul.y), 0, true, 0.2)

            self.timer:after(0.2, function()
                knife.physics.speed = 60
                knife.physics.friction = -0.05
                knife:addFX(ColorMaskFX({1,1,1}, 1))
                knife:setScale(2.25, 0.75)
            end)
        end
        self.timer:after(0.3, function()
            self.timer:tween(0.18, knight, {alpha = 0})
        end)
    end, 11)

    self.timer:after(7.75, function ()
        Game.battle:getEnemyBattler("knight"):setFlag("afterimage", true)
        knight:setFlag("hover", true)
        knight.alpha = 1
        knight:setAnimation("idle")
        Assets.playSound("knight_cut2", 1.5, 1.25)
        knight.x = 550
        knight.y = 280
    end)
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

return Basic
