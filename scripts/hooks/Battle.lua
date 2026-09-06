local Battle, super = HookSystem.hookScript(Battle)


function Battle:powerAct(spell, battler, user, target)

    local user_battler = self:getPartyBattler(user)
    local user_index = self:getPartyIndex(user)

    if user_battler == nil then
        Kristal.Console:error("Invalid power act user: " .. tostring(user))
        return
    end

    if type(spell) == "string" then
        spell = Registry.createSpell(spell)
    end

    local menu_item = {
        data = spell,
        tp = 0
    }

    if target == nil then
        if spell:getTarget() == "ally" then
            target = user_battler
        elseif spell:getTarget() == "party" then
            target = self.party
        elseif spell:getTarget() == "enemy" then
            target = self:getActiveEnemies()[1]
        elseif spell:getTarget() == "enemies" then
            target = self:getActiveEnemies()
        end
    end

    local name = user_battler.chara:getName():upper()
    if name == "SUSIE" then
        -- deltarune inconsistency lol
        name = "Susie"
    end
    self:setActText("* Your SOUL shined its power on Flowery and Ralsei!", true)

    self.timer:after(7 / 30, function()
        Assets.playSound("boost")
        battler:flash()
        user_battler:flash()
        local bx, by = self:getSoulLocation()
        local soul = Sprite("effects/soulshine", bx + 5.5, by)
        soul:play(1 / 30, false, function() soul:remove() end)
        soul:setOrigin(0.3)
        soul:setScale(2, 2)
        self:addChild(soul)
    end)

    self.timer:after(24 / 30, function()
        self:pushAction("SPELL", target, menu_item, user_index)
        self:markAsFinished(nil, { user })
    end)
end


return Battle