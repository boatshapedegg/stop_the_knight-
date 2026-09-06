return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene BattleCutscene
    prophecy_breaker = function(cutscene, battler, enemy)
        -- Open textbox and wait for completion
        local user = cutscene:getCharacter("flowery")
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
        cutscene:text("* nice moves raly", "wink", user)

        cutscene:wait(1)

        cutscene:text("* fuck off", "angrier", "ralsei")

        user:setScale(2)
        user.layer = BATTLE_LAYERS["battlers"]
        user:setAnimation("battle/deflect")
        user:slideTo(119, 142, 0.5)
        target:setFlag("hover", true)
        target:setFlag("shake2", false)
        target:setAnimation("idle")
        stop = stop
        cutscene:wait(0.5)
        cutscene:after(function ()
            user:setAnimation("battle/idle")
        end)
    end
}