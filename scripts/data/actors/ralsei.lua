local actor, super = HookSystem.hookScript("ralsei")

function actor:init()
    super.init(self)

    -- Table of sprite animations
    self.animations2 = {

        -- Battle animations
        ["battle/idle"]         = {"run_angry_right", 0.1, true},
    }

    TableUtils.merge(self.animations, self.animations2)

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["run_serious_right"] = {0, 5},
        ["run_angry_right"] = {0, 5},
    }
end

return actor