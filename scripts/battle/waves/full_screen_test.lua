local Basic, super = Class(Wave)

function Basic:onStart()
    Game.battle.arena:setSize(680, 500)
    self.kris = Game.battle:getPartyBattler("kris")
    self.kris.layer = BATTLE_LAYERS["above_arena"]
    self.kris:setColor(1, 1, 1, 1)
    self.krisx = self.kris.x
    self.krisy = self.kris.y
    Game.battle.arena.layer = BATTLE_LAYERS["background"]
    Game.battle.soul:setPosition(self.kris.x + 12, self.kris.y - 24)
    -- Every 0.33 seconds...
    self.timer:every(1 / 3, function()
        -- Our X position is offscreen, to the right
        local x = SCREEN_WIDTH + 20
        -- Get a random Y position between the top and the bottom of the arena
        local y = MathUtils.random(Game.battle.arena.top, Game.battle.arena.bottom)

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnBullet("smallbullet", x, y, math.rad(180), 8)

        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = false
    end)
end

function Basic:onEnd()
    self.kris:slideTo(self.krisx, self.krisy, 0.5)
end

function Basic:update()
    -- Code here gets called every frame

    self.kris:setPosition(Game.battle.soul.x - 12, Game.battle.soul.y + 24)
    super.update(self)
end

return Basic
