PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.x = 0
	self.y = 0

	self.paddle = Paddle()
	self.ball = Ball(math.random(7))

	self.bricks = LevelMaker.createMap()

	--give ball random starting velocity
	--self.ball.dx = math.random(-200, 200)
	--self.ball.dy = math.random(-200, 200)
	self.ball.dx = 100
	self.ball.dy = -100
	

	--center the ball
	self.ball.x = VIRTUAL_WIDTH / 2 - 4
	self.ball.y = VIRTUAL_HEIGHT / 2 - 4
	self.paused = false
end

function PlayState:update(dt)
	if self.paused then
		if love.keyboard.wasPressed('space') then
			self.paused = false
			gSounds['pause']:play()
		else
			return
		end
	elseif love.keyboard.wasPressed('space') then
		self.paused = true
		gSounds['pause']:play()
		return
	end

	--update positions based on velocity
	self.paddle:update(dt)
	self.ball:update(dt)

	for k, brick in pairs(self.bricks) do
		--only check collision if the brick is in play
		if brick.inPlay and self.ball:collides(brick) then
			brick:hit()
			--detect ball's direction and flip dy accordingly
			self.ball.dy = -self.ball.dy
		end
	end

	if self.ball:collides(self.paddle) then
		--flip the y velocity 
		self.ball.y = VIRTUAL_HEIGHT - 42
		self.ball.dy = -self.ball.dy
		gSounds['paddle-hit']:play()
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function PlayState:render()
	self.paddle:render()
	self.ball:render()

	for k, brick in pairs(self.bricks) do
		brick:render()
	end

	--pause text if paused
	if self.paused then 
		love.graphics.setFont(gFonts['large'])
		love.graphics.printf('Paused', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
	end
end