PlayState = Class{__includes = BaseState}

function PlayState:init()

	self.paddle = Paddle()
	self.ball = Ball(math.random(7))

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

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function PlayState:render()
	self.paddle:render()
	self.ball:render()

	--pause text if paused
	if self.paused then 
		love.graphics.setFont(gFonts['large'])
		love.graphics.printf('Paused', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
	end
end