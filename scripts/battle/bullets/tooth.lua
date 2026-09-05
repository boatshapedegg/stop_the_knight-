local Tooth, super = Class(Bullet)

function Tooth:init(x, y, dir, speed)
    super.init(self, x, y, "bullets/tooth")
	self.rotation = dir + math.rad(270)
	self.physics.direction = dir + math.rad(90)
	self.physics.speed = speed
	self:setLayer(1000)
	self.sprite:setLayer(1000)
	--self:setHitbox(2,2,self.sprite.width-4,self.sprite.height-4)
end

function Tooth:shouldSwoon(damage, target, soul)
	return true
end

function Tooth:update()
    super.update(self)
end

return Tooth