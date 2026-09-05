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

    Game.battle.timer:after(1.5, function()
        Assets.playSound("flowery/" .. TableUtils.pick({"jarona_1", "jarona_2", "jarona_3", "jarona_4"}), 2, 1)

        user:slideTo(tx, ty + 80, 1, "in-quad")

        Game.battle.timer:every(0.125, function ()
            local afterimage = AfterImage(user.sprite, 1, 0.025)
            afterimage.debug_select = false
            afterimage.physics.speed_x = -1
            afterimage:addFX(ColorMaskFX({0,68/255,248/255}, 1))
            user:addChild(afterimage)
        end, 44)

        local next_x, next_y = math.random(tx - 50, tx + 50), math.random(ty + 10, ty + 120)

        Game.battle.timer:after(1, function()
            local timer = 0.6

            local function jarona()
                user.x, user.y = next_x, next_y
                next_x = math.random(tx - 60, tx + 60)
                next_y = math.random(ty, ty + 140)
                user.layer = BATTLE_LAYERS["above_battlers"]

                user:setScale(TableUtils.pick({2, -2}), 2)

                if timer > 0.3 then
                    timer = timer - 0.2
                else
                    timer = 0.16
                end

                Game.battle.timer:tween(timer - 0.05, user, {x = next_x, y = next_y})
                user:setAnimation(TableUtils.pick({"punch", "kick", "flashkick", "axe_kick"}))
                local damage = self:getDamage(user, target)
                Assets.playSound("scytheburst", 1, 0.6)
                target:flash()
                target:hurt(damage, user)
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

                jarona()
                wait(timer)
                Game.battle.timer:tween(1.5, user, {x = target.x - 70, y = target.y})
                user:setAnimation("battle/spell_ready")
            end)
            Game.battle.timer:after(4, function ()
                user:setScale(2)
                user.layer = BATTLE_LAYERS["battlers"]
                user:setAnimation("battle/deflect")
                user:slideTo(ox, oy, 0.5)
                Game.battle.timer:after(0.75, function()
                    Game:getPartyMember("flowery"):setFlag("afterimage", true)
                    Game.battle:finishAction()
                end)
            end)
        end)
    end)
    return false
end

function spell:getDamage(user, target)

    local magic_part = user.chara:getStat("magic")
    local attack_part = (user.chara:getStat("attack") + math.random(-5, 5)) * 6

    local damage = math.ceil(magic_part + attack_part - (target.defense * 4) + math.random(-10, 10))
    return damage
end

return spell
