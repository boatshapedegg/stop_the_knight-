local actor, super = Class(Actor, "knight")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Knight"

    -- Width and height for this actor, used to determine its center
    self.width = 68
    self.height = 65

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = { 0, 25, 19, 14 }

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = { 1, 0, 0 }

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "enemies/knight"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}

    -- Table of sprite animations
    self.animations = {
        -- Looping animation with 0.25 seconds between each frame
        -- (even though there's only 1 idle frame)
        ["idle"]     = {"idle", 0.25, true},
        ["front_on"] = {"front_on", 0.25, true},
        ["attack1"]  = {"attack1", 1/15, false},
        ["attack2"]  = {"attack2", 1/15, false},
        ["static"]   = {"static", 1/15, true},
        ["slash"]    = {"slash", 1/15, false, next = "front_on"},
        ["slash_up"] = {"slash_up", 1/15, false, next = "front_on"},
        ["throw"]    = {"throw", 1/15, false, next = "front_on"},
        ["point"]    = {"point", 0.1, false},
        ["pointend"] = {"pointend", 0.15, false, next = "idle"},
        ["hurt"]     = {"hurt", 1/25, false, temp=true},

        ["clash"]    = {"clash", 1, true},
        ["pull_back"]= {"pull_back", 0.25, false},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Since the width and height is the idle sprite size, the offset is 0,0
        ["idle"]      = {0, 0},
        ["front_on"]  = {10, 0},
        ["attack1"]   = {-30, -26},
        ["attack2"]   = {-30, -26},
        ["slash"]     = {-30, -44},
        ["slash_up"]  = {-20, -34},
        ["throw"]     = {-2, -10},
        ["point"]     = {0, 0},
        ["pointend"]  = {0, 0},
        ["hurt"]      = {-2, -8},
        ["static"]    = {-6, -6},

        ["clash"]     = {-6,-24},
        ["pull_back"] = {-20, 0},
    }

    self.siner = 0

    self.timer = 0
end

--[[function actor:onBattleUpdate(battler)
    local knight = Game.battle:getEnemyBattler("knight")
    if knight:getFlag("afterimage", false) then
        if self.timer == 7 then
            if knight.sprite.sprite then
                self.afterimage = AfterImage(knight.sprite, 0.6, 0.02)
                local afterimage = self.afterimage
                afterimage.x = knight.x + 2
                afterimage.debug_select = false
                afterimage.physics.direction = -math.rad(180)
                afterimage.physics.speed = 1
                knight:addChild(afterimage)
                self.timer = 0
                if knight:getFlag("shake", false) then
                    afterimage.physics.direction = math.rad(math.random(-50, 50))
                end
                if knight:getFlag("shake2", false) then
                    afterimage.physics.direction = math.rad(math.random(360))
                end
            end
        else
            self.timer = self.timer + 1
        end
    end

    if knight:getFlag("hover", false) == true then knight.y = 280 + math.sin(self.siner * 2) * 14 self.siner = self.siner + DT end
end]]--

function actor:onSpriteUpdate(sprite)
    local knight = Game.battle:getEnemyBattler("knight")
    if self.timer == 7 then
        if knight.sprite.sprite then
            self.afterimage = AfterImage(knight.sprite, 0.6, 0.015)
            local afterimage = self.afterimage
            afterimage.debug_select = false
            afterimage.x = afterimage.x + 5
            afterimage.physics.speed = -2
            knight:addChild(afterimage)
            self.timer = 0
            if knight:getFlag("shake", false) then
                afterimage.physics.direction = math.rad(math.random(-50, 50))
            end
            if knight:getFlag("shake2", false) then
                afterimage.physics.direction = math.rad(math.random(360))
            end
        end
    else
        self.timer = self.timer + 1
    end

    self.siner = self.siner + DT
    knight.y = 280 + math.sin(self.siner * 2) * 14
end

return actor
