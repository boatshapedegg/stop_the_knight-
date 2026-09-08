function Mod:init()
    Game:registerEvent("squeak", function(data)
        return Squeak(data.x, data.y, {data.width, data.height, data.polygon})
    end)
    print("Loaded " .. self.info.name .. "!")
end

function Mod:postInit()
    Game:setFlag("move_Clouds", false)
    Game:setFlag("move_ground", false)
end