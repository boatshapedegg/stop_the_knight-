---@class Wave
local FullScreenWave, super = Class(Wave)

function FullScreenWave:init()
    super.init(self)

    self.kris = Game.battle:getPartyBattler("kris")
    self.krisx = self.kris.x
    self.krisy = self.kris.y

    self:setArenaPosition(-90, SCREEN_HEIGHT/2)
    self:setSoulPosition(self.krisx + 12, self.krisy - 24)
    self.layer = BATTLE_LAYERS["below_battlers"]
end

function FullScreenWave:update()
    self.kris:setPosition(Game.battle.soul.x - 12, Game.battle.soul.y + 24)
    super.update(self)
end

function FullScreenWave:onStart()
    self.kris:setColor(1, 1, 1, 1)
    self.kris:addFX(OutlineFX({1, 0, 0}), "outline")
    self:setSoulPosition(self.kris.x + 12, self.kris.y - 24)
    local colliders = {}
    table.insert(colliders, LineCollider(self, 0, 200, SCREEN_WIDTH, 203))
    table.insert(colliders, LineCollider(self, 0, 300, SCREEN_WIDTH, 303))
    table.insert(colliders, LineCollider(self, 10, 200, 13, 480))
    table.insert(colliders, LineCollider(self, 500, 200, 503, 480))
    Game.battle.arena.collider:setColliders(colliders)
end

function FullScreenWave:onEnd(death)
    self.kris:setLayer(BATTLE_LAYERS["battlers"])
    self.kris:slideTo(self.krisx, self.krisy, 0.5)
    self.kris:removeFX("outline")
end

function FullScreenWave:draw()
    love.graphics.setColor(1, 0, 1)
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(5)

    love.graphics.rectangle("fill", 0, 200, SCREEN_WIDTH, 4)
    love.graphics.rectangle("fill", 0, 322, SCREEN_WIDTH, 4)
end

function FullScreenWave:spawnSoul(x, y)
    super.spawnSoul(self)
    Game.battle.soul.fullscreen = true
end

return FullScreenWave