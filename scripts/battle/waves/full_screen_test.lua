local Basic, super = Class(FullScreenWave)

function Basic:onStart()
    Game.battle.arena:setPosition(-300, 0)
    --Game.battle.arena:setSize(680, 500)
    self.kris = Game.battle:getPartyBattler("kris")
    self.layer = BATTLE_LAYERS["below_battlers"]
    self.kris:setColor(1, 1, 1, 1)
    self.krisx = self.kris.x
    self.krisy = self.kris.y
    self.kris:addFX(OutlineFX({1, 0, 0}), "outline")
    Game.battle.soul:setPosition(self.kris.x + 12, self.kris.y - 24)
    local colliders = {}
    table.insert(colliders, LineCollider(self, 0, 200, SCREEN_WIDTH, 203))
    table.insert(colliders, LineCollider(self, 0, 300, SCREEN_WIDTH, 303))
    table.insert(colliders, LineCollider(self, 10, 200, 13, 480))
    table.insert(colliders, LineCollider(self, 500, 200, 503, 480))
    Game.battle.arena.collider:setColliders(colliders)
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
    self.kris:setLayer(BATTLE_LAYERS["battlers"])
    self.kris:slideTo(self.krisx, self.krisy, 0.5)
    self.kris:removeFX("outline")
end

function Basic:update()
    -- Code here gets called every frame

    self.kris:setPosition(Game.battle.soul.x - 12, Game.battle.soul.y + 24)
    super.update(self)
end

function Basic:draw()
    love.graphics.setColor(1, 0, 1)
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(5)

    love.graphics.rectangle("fill", 0, 200, SCREEN_WIDTH, 3)
    love.graphics.rectangle("fill", 0, 400, SCREEN_WIDTH, 3)
end

return Basic
