StartState = Class{__includes = BaseState}

--show whether we're selecting "Start" or "High Scores"
local highlighted = 1

function StartState:update(dt)
	--toggle highlighted if we press up or down arrow key
	if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
		highlighted = highlighted == 1 and 2 or 1
		gSounds['paddle-hit']:play()
	end

	if love.keyboard.wasPressed('return') then
		if highlighted == 1 then
			gSounds['confirm']:play()
			gStateMachine:change('serve', {
				paddle = Paddle(1),
				bricks = LevelMaker:createMap(1)

			})
		end
	end

	--we no longer have this globally so include here
	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function StartState:render()
	--title
	love.graphics.setFont(gFonts['large'])
	love.graphics.printf("Breakout", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

	--instructions
	love.graphics.setFont(gFonts['medium'])

	--render the first option blue if we're highlighting it
	if highlighted == 1 then
		love.graphics.setColor(1, 0, 0.3, 0.9)
	end

	love.graphics.printf("Start", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

	--reset the color
	love.graphics.setColor(1, 1, 1, 1)

	--render the second option blue if we're highlighting it
	if highlighted == 2 then
		love.graphics.setColor(1, 0, 0.3, 0.9)
	end

	love.graphics.printf("High Scores", 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')

	--reset the color
	love.graphics.setColor(0, 1, 1, 1)

end