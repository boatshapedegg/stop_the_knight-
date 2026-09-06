local spell, super = Class(Spell, "prophecy_breaker")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Proph. Breaker"
    -- Name displayed when cast (optional)
    self.cast_name = "Prophecy BREAKER"

    -- Battle description

    self.effect = "My\nJarona"
    -- Menu description
    self.description = "Deals large roommate-damage to\none foe. Depends on Attack & Magic."

    -- TP cost
    self.cost = 99

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
    Assets.playSound("cardrive", 1, 1)

    local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)

    local ox, oy = user.x, user.y

    Game:getPartyMember("flowery"):setFlag("afterimage", false)

    target:setFlag("hover", false)

    Game.battle.timer:after(1.5, function()
        Assets.playSound("flowery/" .. TableUtils.pick({"jarona_1", "jarona_2", "jarona_3", "jarona_4"}), 2, 1)

        user:slideTo(tx - 20, ty + 70, 1, "in-quad")

        Game.battle.timer:every(0.125, function ()
            local afterimage = AfterImage(user.sprite, 1, 0.025)
            afterimage.debug_select = false
            afterimage.physics.speed_x = -1
            afterimage:addFX(ColorMaskFX({0,68/255,248/255}, 1))
            user:addChild(afterimage)
        end, 44)

        local next_x, next_y = tx - 20, ty + 70

        Game.battle.timer:after(1, function()
            target:setFlag("shake2", true)
            local timer = 1.25

            local function jarona(last)
                user.x, user.y = next_x, next_y
                user.layer = BATTLE_LAYERS["above_battlers"]

                user:setAnimation("punch")
                local damage = self:getDamage(user, target) * 4
                Assets.playSound("scytheburst", 1, 0.6)
                target:flash()
                target:hurt(damage, user, false)
                target:setAnimation("static")
            end

            Game.battle.timer:script(function (wait)
                jarona(true)
                wait(timer - 0.05)

                user:setScale(-2, 2)
                user:setAnimation("battle/spell_ready")
                Game.battle.timer:everyInstant(0.25, function()
                    target:shake(math.random(4), math.random(4))
                end, 12)
                Game.battle.timer:everyInstant(1, function()
                    target:flash()
                end, 4)
                Game.battle.timer:tween(0.75, user, {x = target.x - 200, y = target.y - 150})
                wait(0.75)

                local fire = Game.battle:addChild(Sprite("effects/fire_speeding", 130, 260))
                fire:play(1/15, true)
                fire:setScale(2)
                fire:setOrigin(0.5)
                fire.physics.match_rotation = true
                fire.rotation = Utils.angle(130, 260, user.x + 5, user.y - 60)
                fire.physics.speed = 20
                wait(0.35)
                user:setAnimation("axe_kick")
                Assets.playSound("bump", 2, 1)
                fire.rotation = Utils.angle(fire.x, fire.y, tx, ty - 5)
                fire.physics.speed = fire.physics.speed + 1
                wait(0.3)
                fire:remove()
                Assets.playSound("bomb", 1.75, 1)
                target:hurt(self:getDamage(user, target) * 7, user, false)
                target:flash()
                Game.battle.camera:shake(5, 0)

                for i=1, 8 do
                    local angle = ((360/7) * i) * math.pi/180
                    local x_circ = 1 * math.cos(angle) + tx
                    local y_circ = 1 * math.sin(angle) + ty - 5
                    local fire_small = Game.battle:addChild(Sprite("effects/fire_small", x_circ, y_circ))
                    fire_small:setScale(2)
                    fire_small.physics.direction = -Utils.angle(fire_small.x, fire_small.y, tx, ty - 5)
                    fire_small.physics.speed = 2
                    fire_small.physics.spin = math.rad(8)
                    fire_small.physics.friction = -0.25
                    Game.battle.timer:after(1, function()
                        fire_small:fadeOutAndRemove(0.5)
                    end)
                end
            end)
            Game.battle.timer:after(4, function ()
                if not Game:getFlag("prophecied", false) then
                    Game:setFlag("prophecied", true)
                    Game.battle:startCutscene("knight.prophecy_breaker")
                    Game:getPartyMember("flowery"):setFlag("afterimage", true)
                    Game.battle:finishAction()
                else
                    user:setScale(2)
                    user.layer = BATTLE_LAYERS["battlers"]
                    user:setAnimation("battle/deflect")
                    user:slideTo(ox, oy, 0.5)
                    target:setFlag("hover", true)
                    target:setFlag("shake2", false)
                    target:setAnimation("idle")
                    Game.battle.timer:after(0.75, function()
                        Game:getPartyMember("flowery"):setFlag("afterimage", true)
                        Game.battle:finishAction()
                    end)
                end
            end)
        end)
    end)
    return false
end

function spell:getDamage(user, target)

    local magic_part = user.chara:getStat("magic")
    local attack_part = (user.chara:getStat("attack") + math.random(-5, 5)) * 6

    local damage = math.ceil(magic_part + attack_part - (target.defense * 3) + math.random(-10, 10))
    return damage
end

return spell
