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

				self.start = love.timer.getTime()
				HIT = true
				--detect ball's direction and flip dy accordingly

				--from the left
				if self.ball.x + 6 < brick.x and self.ball.dx > 0 then
					self.ball.dx = -self.ball.dx
					--reset the ball so it doesn't go through everything
					self.ball.x = brick.x
				--from the right
				elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
					self.ball.dx = -self.ball.dx
					self.ball.x = brick.x + brick.width
				--from the top 
				elseif self.ball.y + 6 < brick.y and self.ball.dy > 0 then
					self.ball.dy = -self.ball.dy
					self.ball.y = brick.y
				--from the bottom
				elseif self.ball.y + 6 > brick.y + brick.height and self.ball.dy < 0 then
					self.ball.dy = -self.ball.dy
					self.ball.y = brick.y + brick.height
				end

			end

	end

	if self.ball:collides(self.paddle) then
		--flip the y velocity 
		self.ball.y = VIRTUAL_HEIGHT - 42
		self.ball.dy = -self.ball.dy

		--makes it so that hitting the ball on the side of the paddle it came at sends it back in the same direction
		--this is scaled by the region of the paddle hit, so hitting off corners gives you a speed boost and a 
		--shallower angle
		if self.ball.dx > 0 and self.ball.x < self.paddle.x + self.paddle.width / 2 then
			--if the paddle is moving then we send the ball back where it came from, if not let it bounce off normally
			if self.paddle.dx < 0 then
				--flipping the dx and scaling it by the distance from paddle center hit and a scale value
				--math.min is used so that if the angle is too steep and the ball too slow it chooses the default value
				--and just sends it back where it came from with no change in angle
				--math.abs is used to turn the negative value to positive so that the calculations are correct
				self.ball.dx = math.min(-self.ball.dx * math.abs((self.ball.x - (self.paddle.x + self.paddle.width) / 2)) * PADDLE_EDGE_SCALE, -self.ball.dx)
			end
		end

		if self.ball.dx < 0 and self.ball.x > self.paddle.x + self.paddle.width / 2 then
			if self.paddle.dx > 0 then
				--math.max has the same function here as math.min except that dx is positive here so math.max must be used
				self.ball.dx = math.max(-self.ball.dx * math.abs((self.ball.x - (self.paddle.x + self.paddle.width) / 2)) * PADDLE_EDGE_SCALE, -self.ball.dx)
			end
		end

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