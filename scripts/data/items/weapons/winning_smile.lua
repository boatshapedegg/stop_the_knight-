local item, super = Class(Item, "winning_smile")

function item:init()
    super.init(self)

    -- Display name
    self.name = "WinningSmile"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/equip/floweryhead_small"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "The vending machine smile."

    -- Default shop price (sell price is halved)
    self.price = 1
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 0,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        flowery = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "Scoopin' time.",
        ralsei = "Don't scoop me!",
        noelle = "That red... is that blood?",
    }
end

function item:getStatBonuses(character)
    -- TODO: Stat Display callbacks?
    -- Return empty bonuses outside of battle to hide stats visually
    if Game.state ~= "BATTLE" then
        return {
            attack  = 79.2,
            defense = 99,
            magic   = 99,
        }
    end

    return super.getStatBonuses(self, character)
end

return item