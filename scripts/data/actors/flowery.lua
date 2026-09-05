local actor, super = Class(Actor, "flowery")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Flowery"

    -- Width and height for this actor, used to determine its center
    self.width = 39
    self.height = 61

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 25, 19, 14}

    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
    self.soul_offset = {16, 30}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 1, 1}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/flowery"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/flowery"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {

        -- Battle animations
        ["battle/idle"]         = {"idle", 0.2, true},

        ["battle/attack"]       = {"wind_punch", 1/15, false},
        ["battle/act"]          = {"idle", 0.2, false},
        ["battle/spell"]        = {"pose", 0.2, false},
        ["battle/item"]         = {"battle/item", 0.2, false, next="battle/idle"},
        ["battle/spare"]        = {"idle", 0.2, false, next="battle/idle"},

        ["battle/attack_ready"] = {"windup", 0.1, true},
        ["battle/act_ready"]    = {"idle", 0.2, true},
        ["battle/spell_ready"]  = {"pose", 0.2, true},
        ["battle/item_ready"]   = {"idle", 0.2, true},
        ["battle/defend_ready"] = {"deflect", 0.2, true},

        ["battle/act_end"]      = {"idle", 0.2, false, next="battle/idle"},

        ["battle/hurt"]         = {"hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"defeated", 1/15, false},

        ["battle/transition"]   = {"idle", 0.2, true},
        ["battle/intro"]        = {"idle", 1/15, false},
        ["battle/victory"]      = {"idle", 1/10, false},

        ["battle/deflect"]       = {"deflect", 0.2, true},

        ["battle/jarona"]       = {"jarona", 0.2, true},
        ["punch"]               = {"punch", 0.2, true},
        ["kick"]                = {"kick", 0.2, true},
        ["axe_kick"]            = {"axe_kick", 1/25, false},
        ["flashkick"]           = {"flashkick", 0.2, true},

        ["clash"]               = {"clash", 0.3, true},
    }

    -- Tables of sprites to change into in mirrors
    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/left"] = {0, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0},
        ["walk/down"] = {0, 0},

        ["walk_blush/down"] = {0, 0},

        ["slide"] = {0, 0},

        -- Battle offsets
        ["idle"] = {-20, 4},

        ["wind_punch"] = {0, -10},
        ["windup"] = {-5, -10},
        ["battle/attackready"] = {-8, -6},
        ["battle/act"] = {-6, -6},
        ["battle/actend"] = {-6, -6},
        ["battle/actready"] = {-6, -6},
        ["battle/item"] = {-6, -6},
        ["battle/itemready"] = {-6, -6},
        ["deflect"] = {0, -3},

        ["battle/defeat"] = {-8, -5},
        ["hurt"] = {0, 0},

        ["battle/intro"] = {-8, -9},
        ["battle/victory"] = {-3, 0},

        -- Cutscene offsets
        ["knight_clash"] = {-46, -12},
        ["clash"]        = {-44, -14},

        ["pose"] = {-4, -2},
    }
    self.hue = 0

    self.timer = 0

    self.voice_timer = 9
end

function actor:onWorldUpdate(chara)
    self.voice_timer = MathUtils.approach(self.voice_timer, 0, DTMULT)
end

function actor:onBattleUpdate(battler)
    self.hue = (self.hue + DT * 10 / 100) % 1
    self.voice_timer = MathUtils.approach(self.voice_timer, 0, DTMULT)

    local flowery = Game:getPartyMember("flowery")
    local flowery2 = Game.battle:getPartyBattler("flowery")

    if flowery:getFlag("afterimage", false) then
        if self.timer == 10 then
            local afterimage = AfterImage(flowery2.sprite, 1, 0.02)
            afterimage.debug_select = false
            afterimage.physics.speed_x = -3
            afterimage.layer = -1
            afterimage:addFX(ColorMaskFX({ColorUtils.HSVToRGB(self.hue, 1, 0.8)}))
            flowery2:addChild(afterimage)
            self.timer = 0
        else
            self.timer = self.timer + 1
        end
    end
end

function actor:onTextSound()
    if self.voice_timer == 0 then
        local random_num = math.random(1, 3)
        Assets.playSound("voice/flowery_"..random_num)
        self.voice_timer = 5/2
    end

    return true
end

return actor