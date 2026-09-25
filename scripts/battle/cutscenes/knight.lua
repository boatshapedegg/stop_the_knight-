return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene BattleCutscene
    prophecy_breaker = function(cutscene, battler, enemy)
        -- Open textbox and wait for completion
        local user = Game.battle.encounter.flowery
        local target = cutscene:getCharacter("knight")
        local stop = false

        Game.battle.timer:everyInstant(0.25, function()
            if stop == true then return false end
            target:shake(math.random(3), math.random(3))
        end)
        Game.battle.timer:everyInstant(1, function ()
            if stop == true then return false end
            target:flash()
        end)    
        cutscene:setSpeaker(Registry.createActor("flowery"))
        cutscene:text("*[voice:flowery_1] nice moves raly", "wink")
        cutscene:setSpeaker("ralsei")
        cutscene:wait(1)

        cutscene:text("* fuck off", "angrier")

        user:setScale(1)
        user.layer = BATTLE_LAYERS["above_battlers"]
        user:setAnimation("party/flowery/deflect", 0.2, true)
        user:slideTo(40, 28, 0.5)
        target:setFlag("hover", true)
        target:setFlag("shake2", false)
        target:setAnimation("idle")
        stop = true
        cutscene:wait(0.5)
        user:setAnimation("party/flowery/idle", 0.2, true)

    end,
    battle_start = function(cutscene, battler, enemy)
        local knight = cutscene:getCharacter("knight")
        cutscene:getCharacter("kris"):setAnimation("battle/idle")
        cutscene:getCharacter("ralsei"):setAnimation("battle/idle")
        cutscene:wait(2.5)
        Game.world.timer:tween(0.75, Game.battle.encounter.flowery, {x = 40}, "out-back")

        cutscene:wait(2)

        local orb = Sprite("npcs/asgore/orb", SCREEN_WIDTH + 90, knight.y - 200)
        orb:setScale(2)
        orb:setOrigin(0.5)
        orb:setLayer(knight.layer + 2)
        Game.battle:addChild(orb)

        local orb2 = Sprite("npcs/asgore/orb_outline", SCREEN_WIDTH + 90, knight.y - 200)
        orb2:setScale(2)
        orb2:setOrigin(0.5)
        orb2:setLayer(knight.layer + 5)
        Game.battle:addChild(orb2)

        local orb3 = Sprite("npcs/asgore/orb", SCREEN_WIDTH + 90, knight.y - 200)
        orb3:setScale(1.9)
        orb3:setOrigin(0.5)
        orb3:setLayer(knight.layer + 4)
        orb3.alpha = 0.1
        Game.battle:addChild(orb3)

        local rect = Sprite("bullets/stars_mask", SCREEN_WIDTH + 90, knight.y - 200)
        rect:setScale(2)
        rect:setOrigin(0.5)
        rect:setLayer(knight.layer + 6)
        rect.alpha = 0.75
        rect:addFX(MaskFX(orb3))
        rect:setWrap(true)
        rect.physics.speed_x = -8
        Game.battle:addChild(rect)

        local asgore = Sprite("npcs/asgore/trapped", SCREEN_WIDTH + 90, knight.y - 200)
        asgore:setScale(2)
        asgore:setOrigin(0.5)
        asgore:play(0.1, true)
        asgore:setLayer(knight.layer + 3)
        Game.battle:addChild(asgore)
        asgore:addFX(MaskFX(orb))

        local siner = 0

        cutscene:during(function ()
            if not orb then return false end
            siner = siner + DT
            orb:setScale(2 + math.sin(siner / 2) / 5)
            orb2:setScale(2 + math.sin(siner / 2) / 5)
            orb3:setScale(1.9 + math.sin(siner / 2) / 5)

            orb.y = knight.y - 200 + math.sin(siner * 3) * 4
            orb2.y = knight.y - 200 + math.sin(siner * 3) * 4
            orb3.y = knight.y - 200 + math.sin(siner * 3) * 4
            asgore.y = knight.y - 200 + math.sin(siner * 3) * 4
        end)

        orb:slideTo(570, orb.y, 1.6)
        orb2:slideTo(570, orb2.y, 1.6)
        orb3:slideTo(570, orb3.y, 1.6)
        asgore:slideTo(570, asgore.y, 1.6)

        knight:setSprite("down_grab")
        knight:slideTo(550, knight.y, 1.5)
        knight:setFlag("hover", false)

        cutscene:wait(2.5)

        local ralsei = cutscene:getCharacter("ralsei")
        local text = ralsei:spawnSpeechBubble("You cannot run away![wait:10]\nNot again!", {right = true})
        cutscene:wait(function () return text:isRemoved() end)
        cutscene:setSpeaker(Registry.createActor("flowery"))
        cutscene:text("* Heh,[wait:5] that's the spirit, [wait:5] Raly!", "wink")


        orb:slideTo(SCREEN_WIDTH + 85, orb.y, 1.5, "in-back")
        orb2:slideTo(SCREEN_WIDTH + 85, orb2.y, 1.5, "in-back")
        orb3:slideTo(SCREEN_WIDTH + 85, orb3.y, 1.5, "in-back")
        asgore:slideTo(SCREEN_WIDTH + 85, asgore.y, 1.5, "in-back")

        cutscene:wait(1.5)

        orb:remove()
        orb2:remove()
        rect:remove()
        orb3:remove()
        asgore:remove()

        cutscene:wait(0.5)

        knight:setFlag("hover", true)
        knight:setAnimation("idle")
    end,
}