Brick = Class{}

function Brick:init(x, y, colorrr, tier)
	--used for colors and score calculation
	
	self.x = x
	self.y = y

	
	self.color = colorrr
	self.tier = tier

	--tru_color is used to know how much hit's the brick can take before it is destroyed
	--self.tru_color = self.color
	--hit_count is used to know how much more hit's the brick can take(this one is decremented becuause it is not 
	--crucial to rendering the brick, tru_color is not changed)
	self.hit_count = self.tier

	self.score = self.color

	self.score_amt = self.color


	self.width = 32
	self.height = 16

	--this arithmetic is used so that we can decrement the color and not have it affect the arithmetic later on that involves the 
	--score i.e if we modify color independent of tier the result of multiplying would be different. eg 3 - 1 * 2 is not equal to 3 * 2 - 1, pemdas does not apply, opeations are done left to right
	--self.color = self.color * self.tier
	
	

	--uesd to determine whether this brick should be rendered
	self.inPlay = true

	self.psys = love.graphics.newParticleSystem(gTextures['particle'], 1000)
	self.psys:setParticleLifetime(1, 1.5)
	self.psys:setEmissionRate(0)
	self.psys:setSizeVariation(1)
	self.psys:setLinearAcceleration(-15, 0, 15, 80)
	self.psys:setColors(1, 1, 1, 1, 1, 1, 1, 0)
	self.psys:setEmissionArea('normal', 10, 10)


end

function Brick:hit()
	--gSounds['brick-hit-2']:play()
	

	

	playSound(gSounds['brick-hit-1'])

	self.psys:emit(5)

	--every time a brick is hit subtract from it's durability
	self.hit_count = self.hit_count - 1

	--decrement the color by one
	self.tier = self.tier - 1

	--stop rendering the brick if it is destroyed
	if self.hit_count == 0 then
		
		self.inPlay = false
	end

end

function Brick:render()
	if self.inPlay then
		love.graphics.draw(gTextures['main'],
		--multiply color by 4 (-1) to get the color offset
		--then add tier to draw the correct color and tier brick to the screen
		gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier - 1], self.x, self.y)


		
	else
		love.graphics.draw(self.psys, self.x + self.width / 2, self.y + self.height / 2)
	end



end

--used for arithmetic in the PlayState class
function Brick:returnScore()
	return self.score_amt
end

function Brick:update(dt)
	self.psys:update(dt)
end