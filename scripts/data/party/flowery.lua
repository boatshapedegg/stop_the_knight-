local character, super = Class(PartyMember, "flowery")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Flowery"

    -- Actor (handles overworld/battle sprites)
    self:setActor("flowery")

    -- Display level (saved to the save file)
    self.level = 99
    -- Default title / class (saved to the save file)
    self.title = "Roommate\nYour dad's his\nbest friend."
    

    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = 2
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {1, 0, 0}

    -- Whether the party member can act / use spells
    self.has_act = false
    self.has_spells = true

    -- Spells
    self:addSpell("jarona")

    -- Whether the party member can use their X-Action
    self.has_xact = true
    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "F-Action"

    -- Current health (saved to the save file)
    
    self.health = 999

    -- Base stats (saved to the save file)
    self.stats = {
        health = 999,
        attack = 19.8,
        defense = 0,
        magic = 0
        }
    -- Max stats from level-ups
    
    self.max_stats = {
        health = 999
    }

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/icon/floweryhead"

    -- Equipment (saved to the save file)
    self:setWeapon("winning_smile")
    
    self:setArmor(1, "petal_mantle")
    self:setArmor(2, "sunday_best")

    -- Default light world equipment item IDs (saves current equipment)
    self.lw_weapon_default = "light/pencil"
    self.lw_armor_default = "light/bandage"

    -- Character color (for action box outline and hp bar)
    self.color = {245/255, 229/255, 2/255}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {254/255, 229/255, 2/255}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = {254/255, 229/255, 2/255}
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {1, 1, 0}
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = {245/255, 229/255, 2/255}

    -- Head icon in the equip / power menu
    self.menu_icon = "party/flowery/head"
    -- Path to head icons used in battle
    self.head_icons = "party/flowery/icon"
    -- Name sprite
    self.name_sprite = "party/flowery/name"

    -- Effect shown above enemy after attacking it
    self.attack_sprite = "effects/attack/cut"
    -- Sound played when this character attacks
    self.attack_sound = "laz_c"
    -- Pitch of the attack sound
    self.attack_pitch = 1

    -- Battle position offset (optional)
    self.battle_offset = {0, -10}
    -- Head icon position offset (optional)
    self.head_icon_offset = {0, -8}
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil

    -- Message shown on gameover (optional)
    self.gameover_message = nil

    self.flags = {
        ["afterimage"] = true,
    }
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1 then
        local icon = Assets.getTexture("ui/menu/equip/floweryhead_small")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Flowers:    99", x, y)
        return true
    end

    if index == 2 then
        local icon = Assets.getTexture("ui/menu/equip/floweryhead_small")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Floweriness:", x, y)
        return true
    end

    if index == 3 then
        local icon = Assets.getTexture("ui/menu/equip/floweryhead_small")
        local icon2 = Assets.getTexture("ui/menu/icon/floweryhead_smallest")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)
        Draw.draw(icon2, x+110, y+6, 0, 2, 2)
        Draw.draw(icon2, x+127, y+6, 0, 2, 2)
        Draw.draw(icon2, x+144, y+6, 0, 2, 2)
        Draw.draw(icon2, x+161, y+6, 0, 2, 2)
        Draw.draw(icon2, x+178, y+6, 0, 2, 2)
        return true
    end
end

return character