local Basic, super = Class(FullScreenWave)

function Basic:init()
    super.init(self)

    self.time = 13
end

function Basic:onStart()
    super.onStart(self)

    self.frozen = false
    self.parry_timer = math.huge
    self.can_parry = false
    
    local knight = Game.battle:getEnemyBattler("knight")
    knight:setAnimation("point")
    knight:setFlag("hover", false)
    self.timer:after(0.5, function()
        self.timer:everyInstant(2.5, function()
            for i=1, 10 do
                local bullet = self:spawnBullet("star", 640, -20 + 35 * i, math.rad(-180), 20)
            end
        end, 2)
    end)

    self.timer:after(5.5, function()
        Game.battle.encounter.flowery:setSprite("point_cool")

        local maskfx = Game.battle.encounter.flowery:addFX(ColorMaskFX({0,68/255,248/255}, 1))

        Game.battle.timer:tween(0.3, maskfx, {amount = 0})

        Assets.playSound("flowery/no_no_no")
        for i=1, 10 do
            local bullet = self:spawnBullet("star", 640, -20 + 35 * i, math.rad(-180), 20)

            bullet:setColor(0,68/255,248/255)

            local maskfx = bullet:addFX(ColorMaskFX({1, 1, 1}, 1))

            Game.battle.timer:tween(0.2, maskfx, {amount = 0})
        end

        self.timer:after(0.55, function ()
            Game.stage.timer:tween(1, Game.battle, {timescale = 0}, "out-cubic", function ()
                self.parry_timer = 0
                self.frozen = true
            end)
        end)

        self.timer:after(1.5, function ()
            self.timer:everyInstant(2.5, function()
                for i=1, 10 do
                    local bullet = self:spawnBullet("star", 640 + MathUtils.randomInt(-10, 10), -20 + 35 * i, math.rad(-180), 20)
                end
            end, 2)
        end)
    end)
end

function Basic:update()
    -- Code here gets called every frame

    if self.frozen and Input.pressed("confirm") then
        self.frozen = false
        Game.stage.timer:tween(0.75, Game.battle, {timescale = 1}, "in-cubic")
        Game.battle.encounter.flowery:setAnimation("idle", 0.2, true)
    end

    super.update(self)
end

return Basic
