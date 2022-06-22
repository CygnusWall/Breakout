Paddle = Class{}

function Paddle:init()
	--x is placed in the middle
	self.x = VIRTUAL_WIDTH / 2 - 32

	--y is placed a little above the bottom edge of the screen
	self.y = VIRTUAL_HEIGHT - 32

	--starts off with no velocity
	self.dx = 0

	--starting dimensions
	self.width = 64
	self.height = 16

	--the skin only has the effect of changing the color, used to offset us into the gPaddleSkins table later
	self.skin = 1

	--starting paddle size, we start with 2 because 1 will be too small to start with
	self.size = 2

end

function Paddle:update(dt)
	if love.keyboard.isDown('left') then
		self.dx = -PADDLE_SPEED
	elseif love.keyboard.isDown('right') then
		self.dx = PADDLE_SPEED
	else 
		self.dx = 0
	end


	if self.dx < 0 then
		self.x = math.max(0, self.x + self.dx * dt)

	else
		self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
	end
end

function Paddle:render()
	love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)], self.x, self.y)
end
