local ActionBox, super = HookSystem.hookScript(ActionBox)

function ActionBox:init(x, y, index, battler)
    super.init(self, x, y, index, battler)
    if battler.chara:getNameSprite() then
        self.box:removeChild(self.name_sprite)
        self.name_sprite = Sprite(battler.chara:getNameSprite(), battler.chara.name == "Flowery" and 43 or 51, 14)
        self.box:addChild(self.name_sprite)
    end
end

return ActionBox