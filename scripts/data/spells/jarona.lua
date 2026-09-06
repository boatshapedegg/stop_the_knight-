local spell, super = Class(Spell, "jarona")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Jarona"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description

    self.effect = "My\nJarona"
    -- Menu description
    self.description = "Deals large roommate-damage to\none foe. Depends on Attack & Magic."

    -- TP cost
    self.cost = 55

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"damage"}
end

function spell:getCastMessage(user, target)
    return "* Flowery used "..self:getCastName().."!"
end

function spell:onCast(user, target)
    self.flowery = Game.battle.encounter.flowery
    self.flowery:setAnimation("party/flowery/pose", 0.2, true)
    Assets.playSound("cardrive", 1, 1)

    local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)

    local ox, oy = self.flowery.x, self.flowery.y

    self.flowery.afterimage = false

    target:setFlag("hover", false)

    Game.battle.timer:after(1.5, function()
        Assets.playSound("flowery/" .. TableUtils.pick({"jarona_1", "jarona_2", "jarona_3", "jarona_4"}), 2, 1)

        self.flowery:slideTo(tx - 50, ty - 70, 1, "in-quad")

        Game.battle.timer:every(0.125, function ()
            local afterimage = AfterImage(self.flowery, 1, 0.025)
            afterimage.debug_select = false
            afterimage.physics.speed_x = -2
            afterimage:addFX(ColorMaskFX({0,68/255,248/255}, 1))
            user:addChild(afterimage)
        end, 44)

        local next_x, next_y = math.random(tx - 80, tx + 20), math.random(ty - 90, ty + 20)

        Game.battle.timer:after(1, function()
            target:setFlag("shake2", true)
            local timer = 0.6

            local function jarona(last)
                self.flowery.x, self.flowery.y = next_x, next_y
                next_x = math.random(tx - 80, tx + 20)
                next_y = math.random(ty - 90, ty + 20)
                self.flowery.layer = BATTLE_LAYERS["above_battlers"]

                self.flowery:setScale(TableUtils.pick({1, -1}), 1)

                if timer > 0.3 then
                    timer = timer - 0.2
                else
                    timer = 0.16
                end

                Game.battle.timer:tween(timer - 0.05, self.flowery, {x = next_x, y = next_y})
                self.flowery:setAnimation("party/flowery/" .. TableUtils.pick({"punch", "kick", "flashkick", "axe_kick"}), 0.2, false)
                local damage = self:getDamage(user, target, false)
                Assets.playSound("scytheburst", 1, 0.6)
                target:flash()
                target:hurt(damage, user)
                target:setAnimation("static")
            end

            Game.battle.timer:script(function (wait)
                jarona()
                wait(timer)

                jarona()
                wait(timer)

                jarona()
                wait(timer)

                jarona()
                wait(timer)

                jarona()
                wait(timer)

                jarona()
                wait(timer)

                jarona()
                wait(timer)

                jarona()
                wait(timer)

                jarona(true)
                self.flowery:setScale(-1, 1)
                Game.battle.timer:everyInstant(0.25, function()
                    target:shake(math.random(4), math.random(4))
                end, 12)
                Game.battle.timer:everyInstant(1, function()
                    target:flash()
                end, 4)
                wait(timer)
                Game.battle.timer:tween(1.5, self.flowery, {x = target.x - 100, y = target.y - 70})
                self.flowery:setAnimation("party/flowery/pose", 0.2, true)
            end)
            Game.battle.timer:after(4, function ()
                self.flowery:setScale(1)
                self.flowery.layer = BATTLE_LAYERS["above_battlers"]
                self.flowery:setAnimation("party/flowery/deflect", 0.2, true)
                self.flowery:slideTo(ox, oy, 0.5)
                target:setFlag("hover", true)
                target:setFlag("shake2", false)
                target:setAnimation("idle")
                Game.battle.timer:after(0.75, function()
                    self.flowery:setAnimation("party/flowery/idle", 0.2, true)
                    self.flowery.afterimage = true
                    Game.battle:finishAction()
                end)
            end)
        end)
    end)
    return false
end

function spell:getDamage(user, target)

    local magic_part = 0
    local attack_part = (19.8 + math.random(-5, 5)) * 6

    local damage = math.ceil(magic_part + attack_part - (target.defense * 4) + math.random(-10, 10))
    return damage
end

return spell
