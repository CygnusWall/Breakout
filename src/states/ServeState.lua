ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
	--grab game state from params
	self.paddle = params.paddle
	self.bricks = params.bricks

	--ball has to be created since this is the first use
	self.ball = Ball()

	self.ball.skin = math.random(7)
end

function ServeState:update(dt)
	self.paddle:update(dt)

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
end
