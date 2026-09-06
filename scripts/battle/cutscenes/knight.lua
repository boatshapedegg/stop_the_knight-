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
        cutscene:text("*[voice:flowery] nice moves raly", "wink", "flowery")
        cutscene:setSpeaker("ralsei")
        cutscene:wait(1)

        cutscene:text("* fuck off", "angrier", "ralsei")

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
        cutscene:text("You cannot run away! *Not again!", "angry", "ralsei")
        cutscene:setSpeaker("flowery")
        cutscene:text("Heh,[wait:2] that's the spirit, [wait:2] Raly!", "smile")
    end,
}