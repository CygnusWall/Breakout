Brick = Class{}

function Brick:init(x, y)
	--use for colors and score calculation
	self.tier = 0
	self.color = 8

	self.x = x
	self.y = y

	self.width = 32
	self.height = 16

	--uesd to determine whether this brick should be rendered
	self.inPlay = true
end

function Brick:hit()
	--gSounds['brick-hit-2']:play()
	
	playSound(gSounds['brick-hit-1'])
	self.color = self.color - 1
	if self.color == 0 then

		self.inPlay = false
	end
end

function Brick:render()
	if self.inPlay then
		love.graphics.draw(gTextures['main'],
		--multiply color by 4 (-1) to get the color offset
		--then add tier to draw the correct color and tier brick to the screen
		gFrames['bricks'][self.color], self.x, self.y)
	end
end