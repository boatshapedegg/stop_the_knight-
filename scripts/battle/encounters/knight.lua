local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Stop the Knight!"

    -- Battle music ("battle" is rude buster)
    self.music = "flowerman"
    -- Enables the purple grid battle background
    self.background = false

    -- Add the dummy enemy to the encounter
    self.knight = self:addEnemy("knight", 550, 280)

    self.f_voice_timer = 0

    self.timery = 0

    self.hue = 0
end

function Dummy:onBattleStart()
    self.flowery = Game.battle:addChild(FakeFlowery(40, 28))
    
end


function Dummy:update()
    super.update(self)

    self.hue = (self.hue + DT * 12 / 100) % 1
    self.f_voice_timer = MathUtils.approach(self.f_voice_timer, 0, DTMULT)

    if self:getFlag("afterimage", false) then
        if self.timery == 15 then
            local afterimage = AfterImage(self.flowery, 1, 0.02)
            afterimage.debug_select = false
            afterimage.physics.speed_x = -3
            afterimage.layer = -7500
            afterimage:addFX(ColorMaskFX({ColorUtils.HSVToRGB(self.hue, 1, 0.8)}))
            self.flowery:addChild(afterimage)
            self.timery = 0
        else
            self.timery = self.timery + 1
        end
    end
end

function Dummy:getEncounterText()
    local turn = Game.battle.turn_count
    local hard = false

    if turn % 6 == 0 then
        if hard == false then return "* Darkness constricts you."
        else return "* Darkness constricts you.[wait:5]\nYou can barely make out a thing." end
    elseif turn % 5 == 0 then
        if hard == false then return "* Your vision narrows.[wait:5] ...[wait:5] Your head is spinning."
        else return "* You feel cornered." end
    elseif turn % 4 == 0 then
        if hard == false then return "* Tectonic plates shift beneath your feet."
        else return "* It's an earthquake." end
    elseif turn % 3 == 0 then
        if hard == false then return "* Suddenly, the north and east winds blew fiercely."
        else return "* Suddenly, a tempest." end
    elseif turn % 2 == 0 then
        if hard == false then return "* You feel surrounded."
        else return "* Your vision narrows.[wait:5]\nThe world revolves around you." end
    else
        if hard == false then return "* You felt lightheaded.[wait:5]\nYou saw golden stars."
        else return "* You felt lightheaded.[wait:5]\nYou felt a migraine coming on." end
    end
end

function Dummy:isAutoHealingEnabled(battler)
    return false
end

function Dummy:canSwoon(target)
    if target.chara.id == "kris" then
        return false
    end
    return true
end

function Dummy:getPartyPosition(index)
    local x = 80
    local y

    if index == 2 then y = 210
    elseif index == 1 then y = 170 end
    
    local battler = Game.battle.party[index]
    local ox, oy = battler.chara:getBattleOffset()
    x = x + (battler.actor:getWidth() / 2 + ox) * 2
    y = y + (battler.actor:getHeight() + oy) * 2
    return x, y
end

return Dummy
