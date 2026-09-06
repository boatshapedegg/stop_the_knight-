local Basic, super = Class(FullScreenWave)

function Basic:init()
    super.init(self)

    self.time = 9.5
end

function Basic:onStart()
    super.onStart(self)
    -- Every 0.33 seconds...
    self.knives = {}
    self.timer:everyInstant(1.75, function()
        local counter = 1
        local offsetx = math.random(-500, 10)
        self.timer:everyInstant(0.15, function()
            local x, y = self:getAttackers()[1].x + offsetx + 20 * (counter - 1), self:getAttackers()[1].y - 260 + 20 * counter
            local knife = self:spawnBullet("sword_nocode", x, y, Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y), 0, true, 1)
            Game.battle.timer:tween(0.6, knife, {rotation = knife.rotation - math.rad(360)}, "out-cubic", function() knife.launched = false end)
            knife.launched = true
            table.insert(self.knives, knife)

            knife.alpha = 0
            knife.graphics.fade = 0.05
            knife.graphics.fade_to = 1

            self.timer:after(0.85, function ()
                knife.launched = true
                knife.physics.speed = -0.1
                knife.physics.friction = 0.1
            end)
            Game.battle.timer:after(1, function ()
                knife.physics.speed = 70
                knife.physics.friction = -0.25
                knife:addFX(ColorMaskFX({1,1,1}, 1))
                knife:setScale(2.25, 0.75)
            end)
            counter = counter + 1
        end, 6)
    end, 5)
end

function Basic:update()
    -- Code here gets called every frame
    for i, knife in ipairs(self.knives) do
        if knife.launched == false then
            knife.rotation = Utils.angle(knife.x, knife.y, Game.battle.soul.x, Game.battle.soul.y)
        end
    end

    super.update(self)
end

return Basic
