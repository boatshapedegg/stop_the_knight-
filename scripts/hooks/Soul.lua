---@class Soul : Object
local Soul, super = HookSystem.hookScript(Soul)

function Soul:init(x, y, color)
    super.init(self, x, y)

    self.fullscreen = false
end

function Soul:update()
    if self.transitioning then
        if self.fullscreen == true then self.target_x = 103 self.target_y = 246 end
    end

    super.update(self)
end

return Soul
