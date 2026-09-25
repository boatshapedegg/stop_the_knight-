local Basic, super = Class(FullScreenWave)

function Basic:init()
    super.init(self)

    self.time = 11.5
end

function Basic:onStart()
    super.onStart(self)
    -- Every 0.33 seconds...
    self.knives = {}
    self.timer:everyInstant(3, function()
        local bullet = self:spawnBullet("parrybullet", 550, 230, Utils.angle(550, 230, Game.battle.soul.x, Game.battle.soul.y), 15)

        function bullet:onParry()
            Game.battle:getEnemyBattler("knight"):alert()
        end
    end)
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

return Basic
