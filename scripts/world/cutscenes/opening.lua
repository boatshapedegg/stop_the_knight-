---@param cutscene WorldCutscene
return function(cutscene)
    local kris = cutscene:getCharacter("kris")
    local ral = cutscene:getCharacter("ralsei")

    cutscene:detachFollowers()
    ral:setPosition(-20, kris.y + 40)

    kris:setSprite("fell")

    cutscene:wait(2)

    local asgore = cutscene:spawnNPC("asgore", 640, kris.y)
    asgore:setAnimation("run")

    local goregore = Game.world.timer:tween(1.6, asgore, {x = kris.x + 40})

    cutscene:wait(1)

    local knight = cutscene:spawnNPC("knight", -30, asgore.y + 8)

    knight:setAnimation("fly")
    
    knight.physics.speed = 50

    knight.layer = asgore.layer + 20

    cutscene:wait(0.2)

    Game.world.timer:cancel(goregore)

    asgore:setAnimation("kidnapped")
    asgore.physics.speed = 50

    cutscene:wait(1)

    ral:walkTo(kris.x - 20, ral.y, 0.75)

    cutscene:wait(2)

    knight:remove()
    asgore:remove()

    Game:setFlag("move_Clouds", true)
    Game:setFlag("move_ground", true)

    cutscene:startEncounter("knight", false)
end