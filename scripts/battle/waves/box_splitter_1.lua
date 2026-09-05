local BoxSlash, super = Class(Wave)

function BoxSlash:init()
	super.init(self)
	self.arena_sizes = 150
	self:setArenaSize(self.arena_sizes,self.arena_sizes)
	self.arena_mask = Sprite("bullets/arena_mask1")
	self.arena_tilt = "width"
	self.nubert = 1
	self.hard_mode = false -- I explain this somewhere else in the lua, you just gotta find her!
    self.attack_counter = 0
    self.time = 9.2 -- Definitely not neccesary
end

function BoxSlash:onStart()
    Game.battle:getEnemyBattler("knight"):setFlag("hover", false)
	local arena = Game.battle.arena
	local soul = Game.battle.soul
	Game.battle:addChild(self.arena_mask)
	self.arena_mask:setPosition(318,92 - (self.arena_sizes-150)/2)
	self.arena_mask:setOrigin(0.5,0)
	arena:addFX(MaskFX(self.arena_mask))
	self.arena_mask.visible = false
    Game.battle.enemies[1]:setAnimation("attack1")
	self.timer:everyInstant(1.05, function() -- Don't ask questions you don't want answered
        local widthorheight
        self.timer:after(0.1, function()
            Assets.playSound("knight_rotatingslash_line", 1.25)
            self.slash = Sprite("bullets/slash", 320, 170)
            self.slash:setScale(3.5, 1)
            self.timer:tween(0.6, self.slash, {scale_x = 0}, "in-quad")
            self.timer:tween(0.3, self.slash, {scale_y = 4}, "in-quad")
            self.slash:setOrigin(0.5)
            self.slash:setColor(COLORS.red)
            self.slash.alpha = 0.1
            self.slash.graphics.fade = 0.05
            self.slash.graphics.fade_to = 0.6
            self.slash:setLayer(1000)
            Game.battle:addChild(self.slash)
            local numbre
            widthorheight = math.random(2)
            if widthorheight == 1 then numbre = 90 -- Rotation of the slash
            else numbre = 180 end
            self.slash.rotation = math.rad(numbre + TableUtils.pick({math.random(-70, -40), math.random(40, 70)}))
            self.timer:tween(0.6, self.slash, {rotation = math.rad(numbre + math.random(-20,20))}, "out-quad") -- Rotate the slash
            self.slash:setOrigin(0.5)
        end)
        self.timer:after(0.7, function ()
            self.slash:setColor(COLORS.red)
            Game.battle:removeChild(self.slash)
            self.slash:remove() -- Since you respawn the slash setting the colour back to WHITE is necessary trust
            Game.battle.timer:after(0.2, function()
                self.slash2 = Sprite("bullets/slash")
                self.slash2.rotation = self.slash.rotation
                self.slash2:setPosition(320, 170)
                self.slash2.layer = self.slash.layer + 1
                self.slash2:setScale(2.5, 3.25)
                self.slash2:setOrigin(0.5)
                Game.battle:addChild(self.slash2)
                self.timer:tween(0.3, self.slash2, {scale_x = 0}, "in-quad", function ()
                    self.slash2:remove()
                end)
            end)
        end)
		self.timer:after(1, function()
            self.attack_counter = self.attack_counter + 1
            if self.attack_counter % 2 == 0 then Game.battle.enemies[1]:setAnimation("attack1")
            else Game.battle.enemies[1]:setAnimation("attack2") end
			Assets.stopSound("knight_rotatingslash_line")

			self.arena_mask:setSprite("bullets/arena_mask2") -- Set sprite to the "slash" mask

		    Assets.playSound("knight_teleport")
			Assets.playSound("knight_cut")
			Assets.playSound("knight_boxbreak")
			--Assets.playSound("boing") (DON'T ASK)
			if widthorheight == 2 then -- This is because the slash's rotation is about math.pi (though it's off by 1e-16, no seriously! You can't make this shit up!)
				self.timer:tween(0.5, Game.battle.arena, {width = self.arena_sizes + 130}, "out-quad")
				self.arena_tilt = "width"
				self.arena_mask.rotation = math.rad(0)
				self.arena_mask:setPosition(319,92 - (self.arena_sizes-150)/2)
			else
				self.timer:tween(0.5, Game.battle.arena, {height = self.arena_sizes + 130}, "out-quad")
				self.arena_tilt = "height"
				self.arena_mask.rotation = math.rad(90)
				self.arena_mask:setPosition(319 + 80,172 - (self.arena_sizes-150)/2)
			end
			for i = 1, 2 do -- How does the flame code make up over a third of this wave lua :sob:
				local flames = self:addChild(Sprite("bullets/arena_flames"))
				flames:play(1/8, true)
				if self.arena_tilt == "width" then
					flames.x = 320 + 33 - (i * 65 - 65) -- Einstein levels of mathematics going on
					flames.y = 172
				else
					flames.x = 320
					flames.y = 172 + 33 - (i * 65 - 65)
				end
				flames:setScale(2)
				flames.alpha = 0.75
				flames:setOrigin(0.5,0)
				if self.arena_tilt == "width" then -- Flame rotation
					if i == 1 then
						flames.rotation = math.rad(90)
					else
						flames.rotation = math.rad(-90)
					end
				else
					if i == 1 then
						flames.rotation = math.rad(180)
					else
						flames.rotation = math.rad(0)
					end
				end
				if self.arena_tilt == "width" then -- Flame movement
					if i == 1 then
						flames:slideTo(flames.x - 65, flames.y, 0.5, "out-quad")
						self.timer:after(0.5, function()
							flames:slideTo(flames.x + 65, flames.y, 0.5, "in-quad")
						end)
					else
						flames:slideTo(flames.x + 65, flames.y, 0.5, "out-quad")
						self.timer:after(0.5, function()
							flames:slideTo(flames.x - 65, flames.y, 0.5, "in-quad")
						end)
					end
				else
					if i == 1 then
						flames:slideTo(flames.x, flames.y - 65, 0.5, "out-quad")
						self.timer:after(0.5, function()
							flames:slideTo(flames.x, flames.y + 65, 0.5, "in-quad")
						end)
					else
						flames:slideTo(flames.x, flames.y + 65, 0.5, "out-quad")
						self.timer:after(0.5, function()
							flames:slideTo(flames.x, flames.y - 65, 0.5, "in-quad")
						end)
					end
				end
				self.timer:after(0.85, function()
					flames:fadeOutAndRemove(0.15) -- Probably not how it works in Deltarune, eh whatever!
				end)
				flames:setLayer(-2000)
				flames:addFX(MaskFX(arena))
			end
			local nubert = 1 -- I name all of my random variables "nubert".
			local slow = 0
			if self.arena_tilt == "width" then -- Handle the teeth
				for i = 1, 6 do
					nubert = math.random(2)
					if i > 4 and self.hard_mode == true then -- If you want TRUE Knighting :P (This is not how it works in Deltarune.)
						nubert = nubert + math.random(2)
					end
					if nubert == 1 and slow < 4 then
						local tooth = self:spawnBullet("tooth", 320, 84 + i * 25, math.rad(90), 2)
                        tooth.physics.friction = math.random(-0.1, -0.3)
						slow = slow + 1
					else
						local tooth = self:spawnBullet("tooth", 320, 84 + i * 25, math.rad(90), 3)
                        tooth.physics.friction = math.random(-0.3, -0.5)
					end
				end
				for i = 1, 6 do
					nubert = math.random(2)
					if i > 4 and self.hard_mode == true then
						nubert = nubert + math.random(1,2)
					end
					if nubert == 1 and slow < 4 then
						local tooth = self:spawnBullet("tooth", 320, 84 + i * 25, math.rad(270), 2)
                        tooth.physics.friction = math.random(-0.1, -0.3)
						slow = slow + 1
					else
						local tooth = self:spawnBullet("tooth", 320, 84 + i * 25, math.rad(270), 3)
                        tooth.physics.friction = math.random(-0.3, -0.5)
					end
				end
			else
				for i = 1, 6 do
					nubert = math.random(2)
					if i > 4 and self.hard_mode == true then
						nubert = nubert + math.random(1,2)
					end
					if nubert == 1 and slow < 4 then
						local tooth = self:spawnBullet("tooth", 230 + i * 25, 172, 0, 2)
                        tooth.physics.friction = math.random(-0.1, -0.3)
						slow = slow + 1
					else
						local tooth = self:spawnBullet("tooth", 230 + i * 25, 172, 0, 3)
                        tooth.physics.friction = math.random(-0.3, -0.5)
					end
				end
				for i = 1, 6 do
					nubert = math.random(2)
					if i > 4 and self.hard_mode == true then
						nubert = nubert + math.random(1,2)
					end
					if nubert == 1 and slow < 4 then
						local tooth = self:spawnBullet("tooth", 230 + i * 25, 172, math.rad(180), 2)
                        tooth.physics.friction = math.random(-0.1, -0.3)
						slow = slow + 1
					else
						local tooth = self:spawnBullet("tooth", 230 + i * 25, 172, math.rad(180), 3)
                        tooth.physics.friction = math.random(-0.3, -0.5)
					end
				end
			end
			arena:shake(1,1,0)
			for _, v in ipairs(Game.battle:getActiveParty()) do
				local af = AfterImage(v, 0.4, 0.075)
				if self.arena_tilt == "width" then
					af:slideTo(v.x, v.y - 200, 1)
				else
					af:slideTo(v.x + 200, v.y, 1)
				end
				af.layer = BATTLE_LAYERS["top"]
				af.debug_select = false
				Game.battle:addChild(af)
			end
			self.timer:after(0.5, function() -- Reset the slash
				self.timer:tween(0.5, Game.battle.arena, {width = self.arena_sizes}, "in-quad")
				self.timer:tween(0.5, Game.battle.arena, {height = self.arena_sizes}, "in-quad")
				arena:shake(0)
			end)
		end)
	end)
end

function BoxSlash:beforeEnd()
	self.slash:remove()
    self.slash2:remove()
    Game.battle.enemies[1]:setAnimation("idle")
    Game.battle:getEnemyBattler("knight"):setFlag("hover", true)
end

function BoxSlash:update()
	super.update(self)
	-- If you're wondering how the slash works, its with these six lines:
	if self.arena_tilt == "width" then
		self.arena_mask.scale_x = MathUtils.clamp(Game.battle.arena.width / 5 - self.arena_sizes / 5, 1, math.huge)
	elseif self.arena_tilt == "height" then
		self.arena_mask.scale_x = MathUtils.clamp(Game.battle.arena.height / 5 - self.arena_sizes / 5, 1, math.huge)
	end
	self.arena_mask.scale_y = self.arena_sizes / 150
end

return BoxSlash
