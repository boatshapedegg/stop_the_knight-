local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super.init(self)

    -- Enemy name
    self.name = "Knight"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("knight")
    multiplier = 0.2

    -- Enemy health
    self.max_health = 7300
    self.health = 7300
    -- Enemy attack (determines bullet damage)
    self.attack = 40
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 100
    self.disable_mercy = true

    self.tired_percentage = -math.huge

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    -- List of possible wave ids, randomly picked each turn
    self.waves = {}

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "Nothing happened."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Why couldn't the skeleton go to the dance?"
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* Because he was [color:red]Ugly[color:reset], [color:red]FAT[color:reset], and nobody liked him."

    self.flags = {
        ["hover"] = true,
        ["shake"] = false,
        ["afterimage"] = true
    }

    self.battle_offset = {0, 10}

    self:registerAct("Proph. Breaker", "Change The\nFuture", {"ralsei"}, 75, self, {"party/flowery/icon/head"})
    self:registerAct("Jarona", "His\nJarona", nil, 99, self, {"party/flowery/icon/head"})
end

function Dummy:onTurnEnd()
    local raly = Game.battle:getPartyBattler("ralsei")
    if raly.is_down == true then
        self:registerAct("X-Slash", "Physical\nDamage", nil, 25, self)
    end
end

function Dummy:onAct(battler, name)
    if name == "Standard" then
        return "* There isn't time for this."
    elseif name == "Proph. Breaker" then
        Game.battle:powerAct("prophecy_breaker", battler, "ralsei", self)
    elseif name == "Jarona" then
        Game.battle:powerAct("jarona", battler, "ralsei", self)
    elseif name == "Check" then
        return "* No info found!"
    elseif name == "X-Slash" then
        local user = "kris"
        local user_index = Game.battle:getPartyIndex(user)
        local user_battler = Game.battle:getPartyBattler(user)
        local spell = Registry.createSpell("xslash")
        local target = self
        local menu_item = {
            data = spell,
            tp = 0,
        }
        Game.battle:pushAction("SPELL", target, menu_item, user_index)
        Game.battle:markAsFinished(nil, {user})
    end
    

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
end
    

function Dummy:getHealthDisplay()
    return "???"
end

function Dummy:onHurt(damage, battler, hurt)
    if damage > 100 then
        self:setFlag("shake", true)

        if hurt == false then
            self:toggleOverlay(true)
            if not self:getActiveSprite():setAnimation("hurt") then
                self:toggleOverlay(false)
            end
        end
        self:getActiveSprite():shake(9, 0, 1, 2 / 30, true)
    else
        self:getActiveSprite():shake(5, 0, 1, 2 / 30, true)
    end
end

function Dummy:onHurtEnd()
    super.onHurtEnd(self)

    self:setFlag("shake", false)
end

function Dummy:selectWave()
    local turn = Game.battle.turn_count
    local hard = self.health <= self.max_health * 0.6

    if turn % 6 == 0 then
        if hard == false then
            self.selected_wave = "knight/fountain_maker_1"
        else
            self.selected_wave = "knight/fountain_maker_2"
        end
    elseif turn % 5 == 0 then
        if hard == false then
            self.selected_wave = "knight/sword_corridor_1"
        else
            self.selected_wave = "knight/sword_corridor_2"
        end
    elseif turn % 4 == 0 then
        if hard == false then
            self.selected_wave = "knight/sword_box_1"
        else
            self.selected_wave = "knight/sword_box_2"
        end
    elseif turn % 3 == 0 then
        if hard == false then
            self.selected_wave = "knight/box_splitter_1"
        else
            self.selected_wave = "knight/box_splitter_2"
        end
    elseif turn % 2 == 0 then
        if hard == false then
            self.selected_wave = "knight/sword_trackers_1"
        else
            self.selected_wave = "knight/sword_trackers_2"
        end
    else
        if hard == false then
            self.selected_wave = "full_screen_test"
        else
            self.selected_wave = "knight/stars_2"
        end
    end
    return self.selected_wave
end

function Dummy:getAttackDamage(damage, battler, points)
    if damage > 0 then
        return damage
    end
    multiplier = 0.2
    local ralsei = Game.battle:getPartyBattler("ralsei")

    multiplier = MathUtils.clamp(multiplier + Game.battle.turn_count / 100, 0, 0.35)
    if battler.chara.id == "kris" and not ralsei.is_down then
        multiplier = multiplier / 2
    elseif battler.chara.id == "kris" and ralsei.is_down then
        multiplier = multiplier * 3.5
    end

    return (((battler.chara:getStat("attack") * points) / 20) - (self.defense * 3)) * multiplier
end

return Dummy