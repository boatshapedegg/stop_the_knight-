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
    self:addEnemy("knight", 550, 280)
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

    if index == 3 then y = 210
    elseif index == 1 then y = 170
    elseif index == 2 then y = 40 end
    
    local battler = Game.battle.party[index]
    local ox, oy = battler.chara:getBattleOffset()
    x = x + (battler.actor:getWidth() / 2 + ox) * 2
    y = y + (battler.actor:getHeight() + oy) * 2
    return x, y
end

return Dummy
