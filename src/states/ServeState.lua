ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
	--grab game state from params
	self.paddle = params.paddle
	self.bricks = params.bricks

	--ball has to be created since this is the first use
	self.ball = Ball()
	self.second = 0
	self.minute = 0

	self.double_digits = true
	

	self.ball.skin = math.random(7)
end

function ServeState:update(dt)
	self.paddle:update(dt)

	--increment timer by deltatime
	self.second = self.second + dt

	--modulo would not work here, not sure why, opted to use this if statement instead
	--it says greater than or equal to because if the seconds overshoot the value 60 then the loop will not execute
	if self.second >= 60 then
		self.second = 0
		self.minute = self.minute + 1
	end

	--if the minutes timer is in the double digits shift it around to make room for the seconds
	if self.minute >= 10 and self.double_digits then
		X_OFFSET = X_OFFSET + 5
		self.double_digits = false
	end

	--move the ball with the paddle
	self.ball.x = self.paddle.x + (self.paddle.width / 2) - self.ball.width / 2
	self.ball.y = self.paddle.y - 10

	if love.keyboard.wasPressed('return') then
			gSounds['confirm']:play()
			gStateMachine:change('play', {
				paddle = self.paddle,
				bricks = self.bricks,
				ball = self.ball,
				skin = self.ball.skin
				
			})
		
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function ServeState:render()
	self.paddle:render()
	self.ball:render()

	--render the minutes
	love.graphics.print('Timer: ' .. tostring(self.minute), VIRTUAL_WIDTH - X_OFFSET, 20)
	--render the seconds
	love.graphics.print(':' .. tostring(math.floor(self.second)), VIRTUAL_WIDTH - 28, 20)
	--make the numbers shift around dynamically when the number of digits increase...coming soon
end
