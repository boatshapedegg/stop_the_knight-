local FakeFlowery, super = Class(Object)

function FakeFlowery:init(x, y)
    super.init(self, x, y)

    self.sprite = self:addChild(Sprite("party/flowery/idle", 0, 0))
    self.sprite:setScale(2)
    self.sprite:play(0.15)

    self.hue = 0

    self.timer = 0

    self.afterimage = true
end

function FakeFlowery:update()
    super.update(self)
    
    self.hue = (self.hue + DT * 12 / 100) % 1

    if self.afterimage then
        if self.timer == 15 then
            local afterimage = AfterImage(self.sprite, 1, 0.02)
            afterimage.debug_select = false
            afterimage.physics.speed_x = -3
            afterimage.layer = -1
            afterimage:addFX(ColorMaskFX({ColorUtils.HSVToRGB(self.hue, 1, 0.8)}))
            self:addChild(afterimage)
            self.timer = 0
        else
            self.timer = self.timer + 1
        end
    end
end

return FakeFlowery