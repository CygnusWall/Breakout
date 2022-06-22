Ball = Class{}

function Ball:init(skin)
	self.width = 8
	self.height = 8

	self.dx = 0
	self.dy = 0

	self.skin = skin
end

function Ball:collides(target)
	--checks to see if the left edge of either is farther to the right than the left edge of the other 
	if self.x > target.x + target.width or target.x > self.x + self.width then
		return false
	end

	--checks to see the bottom edge of either is higher than the top edge of the other
	if self.y > target.y + target.width or target.y > self.y + self.width then
		return false
	end

	--both of these if statements factor in the size of the object, if they aren't true then they're overlapping
	return true
end

function Ball:reset()
	self.x = VIRTUAL_WIDTH / 2 - 2
	self.y = VIRTUAL_HEIGHT / 2 - 2
	self.dx = 0
	self.dy = 0
end

function Ball:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	--allow ball to bounce off walls
	if self.x + self.width > VIRTUAL_WIDTH then
		self.x = VIRTUAL_WIDTH - self.width
		self.dx = -self.dx
		gSounds['wall-hit']:play()
	end

	if self.x <= 0 then
		self.x = 0
		self.dx = -self.dx
		gSounds['wall-hit']:play()
	end

	if self.y <= 0 then
		self.y = 0
		self.dy = -self.dy
		gSounds['wall-hit']:play()
	end

	--allows ball to bounce off the bottom for debugging purposes
	if self.y > VIRTUAL_HEIGHT then
		self.y = VIRTUAL_HEIGHT - self.height
		self.dy = -self.dy
		gSounds['wall-hit']:play()
	end

end

function Ball:render()
	--main is the sprite sheet and balls is the subsection of the sprite sheet containing the balls
	--skin is one of the seven balls available
	love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin], self.x, self.y)
end