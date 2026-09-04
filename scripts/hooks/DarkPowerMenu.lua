---@class DarkPowerMenu : Object
---@
local DarkPowerMenu, super = HookSystem.hookScript(DarkPowerMenu)

function DarkPowerMenu:init()
    super.init(self)

    self.flowery_sound = Assets.newSound("flowery/no_no_no")
end

function DarkPowerMenu:update()
    if self.state == "PARTY" then
        if Input.pressed("confirm") then
            if #self:getSpells() > 0 then
                if Game.party[self.party.selected_party].name == "Flowery" then
                    --Assets.playSound("ui_cant_select") -- for testing purposes, remove if you want
                    self.flowery_sound:stop()
                    self.flowery_sound:play()
                    return
                end
                self.state = "SPELLS"

                self.party.focused = false

                self.ui_select:stop()
                self.ui_select:play()

                self.selected_spell = 1
                self.scroll_y = 1

                self:updateDescription()
            else
                self.ui_select:stop()
                self.ui_select:play()
            end
        end
    end
    super.update(self)
end


return DarkPowerMenu
