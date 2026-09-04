local actor, super = HookSystem.hookScript("kris")

function actor:init()
    super.init(self)

    -- Table of sprite animations
    self.animations2 = {

        -- Battle animations
        ["battle/idle"]         = {"sword_running", 0.1, true},
    }

    TableUtils.merge(self.animations, self.animations2)

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["sword_running"] = {-10, 5},
    }
end

return actor