PlayState = Class{__includes = BaseState}

--[[function PlayState:init()
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
]]--

function PlayState:enter(params)
	--grab game state from params
	self.paddle = params.paddle
	self.bricks = params.bricks

	self.ball = params.ball
	self.ball.skin = params.skin

	self.score = 0


	--hearts has to be created since this is the first time use
	self.hearts = Hearts()
	self.brick = Brick()

	--allows the player to guide the ball based on what direction the paddle is moving
	--may be a lot cleaner with an if statement but I wanted to implement it with math
	self.ball.dx = self.paddle.dx + math.random(-200, 200)
	self.ball.dy = -100

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



	--ball bouncing


	--allow ball to bounce off walls
	--right wall
	if self.ball.x + self.ball.width > VIRTUAL_WIDTH then
		self.ball.x = VIRTUAL_WIDTH - self.ball.width
		self.ball.dx = -self.ball.dx
		gSounds['wall-hit']:play()
	end

	--left wall
	if self.ball.x <= 0 then
		self.ball.x = 0
		self.ball.dx = -self.ball.dx
		gSounds['wall-hit']:play()
	end

	--ceiling
	if self.ball.y <= 0 then
		self.ball.y = 0
		self.ball.dy = -self.ball.dy
		gSounds['wall-hit']:play()
	end

	--allows ball to bounce off the floor for debugging purposes
	if self.ball.y > VIRTUAL_HEIGHT then
		self.ball.y = VIRTUAL_HEIGHT - self.ball.height
		self.ball.dy = -self.ball.dy
		--gSounds['wall-hit']:play()
		self.hearts:hit()
	end

	
	



	for k, brick in pairs(self.bricks) do
			--only check collision if the brick is in play
			if brick.inPlay and self.ball:collides(brick) then
				brick:hit()
				brick:update(dt)
				self.hearts.hearts = self.hearts.hearts + 1

				--self.score = self.score + self.brick:returnScore()
				HIT = true
				--detect ball's direction and flip dy accordingly

				--from the left
				if self.ball.x + 2 <= brick.x and self.ball.dx > 0 then
					self.ball.dx = -self.ball.dx
					--reset the ball so it doesn't go through everything
					self.ball.x = brick.x
				--from the right
				elseif self.ball.x + 10 >= brick.x + brick.width and self.ball.dx < 0 then
					self.ball.dx = -self.ball.dx
					self.ball.x = brick.x + brick.width
				--from the top 
				elseif self.ball.y + self.ball.width >= brick.y and self.ball.dy > 0 then
					self.ball.dy = -self.ball.dy
					self.ball.y = brick.y - self.ball.height
				--from the bottom
				else -- self.ball.y + 6 > brick.y + brick.height and self.ball.dy < 0 then
					self.ball.dy = -self.ball.dy
					self.ball.y = brick.y + brick.height
				end

			end

	end

	if self.ball:collides(self.paddle) then
		--flip the y velocity if it collides from the top
		if self.ball.dy > 0 and self.ball.y + self.ball.height >= self.paddle.y and self.ball.y <= self.paddle.y + 2 then
			--reset the ball on top of paddle to avoid infinite collision
			self.ball.y = self.paddle.y - self.ball.height
			--flip the y velocity
			self.ball.dy = -self.ball.dy

			gSounds['paddle-hit']:play()

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
		

		--checks for left and right collision
		--left incoming
		elseif self.ball.x + self.ball.width + 2 >= self.paddle.x and self.ball.dx > 0 and self.ball.dy > 0 then
			if self.paddle.dx == 0 then
			 	gSounds['hurt']:play()
				self.ball.dx = -self.ball.dx
				--reset the ball x outside of paddle
				self.ball.x = self.paddle.x - self.ball.width - 5
			else
				gSounds['brick-hit-1']:play()
				self.ball.dx = -self.ball.dx
				--reset the ball x outside of paddle
				self.ball.x = self.paddle.x - self.ball.width - 15
			end

		--right incoming
		elseif self.ball.x - 2 <= self.paddle.x + self.paddle.width and self.ball.dx < 0 and self.ball.dy > 0 then

			if self.paddle.dx == 0 then
				gSounds['hurt']:play()
				self.ball.dx = -self.ball.dx
				--reset the ball outside of paddle
				--self.ball.x = self.paddle.x + self.paddle.width
				self.ball.x = self.paddle.x + self.paddle.width + 5
			else
				gSounds['brick-hit-1']:play()
				self.ball.dx = -self.ball.dx
				--reset the ball x outside of paddle
				self.ball.x = self.paddle.x + self.paddle.width + 15
			end

		else
		--checks for bottom collision
		--elseif self.ball.dy < 0 then
			self.ball.dy = -self.ball.dy
			self.ball.y = self.paddle.y + self.paddle.height + 6
			gSounds['confirm']:play()

		end
		
	end

	for k, brick in pairs(self.bricks) do
		brick:update(dt)
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function PlayState:render()
	self.paddle:render()
	self.ball:render()

	self.hearts:render()

	for k, brick in pairs(self.bricks) do
		brick:render()
	end

	--self.brick:returnScore()

	love.graphics.print('Score: ' .. tostring(self.score), VIRTUAL_WIDTH - 40, 20)

	--pause text if paused
	if self.paused then 
		love.graphics.setFont(gFonts['large'])
		love.graphics.print('Paused', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
	end
end