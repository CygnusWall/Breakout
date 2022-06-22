-- Josiah Polite's version of Harvards GD50 Breakout

require 'src/Dependencies'

-- called once at the begining of the game to set up objects, variables etc

function love.load()

	-- set the default filter to 'nearest neighbour' so that the pixelated look isn't smoothed out
	love.graphics.setDefaultFilter('nearest', 'nearest')

	-- using the time since last epoch to seed the random number generator so that it is different every time
	math.randomseed(os.time())

	love.window.setTitle('Breakout')

	gFonts = {
		['small'] = love.graphics.newFont('fonts/font.ttf', 8),
		['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
		['large'] = love.graphics.newFont('fonts/font.ttf', 32)
	}

	love.graphics.setFont(gFonts['small'])

	gTextures = {
		['background'] = love.graphics.newImage('graphics/background.png'),
		['main'] = love.graphics.newImage('graphics/breakout.png'),
		['arrows'] = love.graphics.newImage('graphics/arrows.png'),
		['hearts'] = love.graphics.newImage('graphics/hearts.png'),
		['particle'] = love.graphics.newImage('graphics/particle.png')
	}

	gFrames = {
		['paddles'] = GenerateQuadsPaddles(gTextures['main']),
		['balls'] = GenerateQuadsBalls(gTextures['main']),
		['bricks'] = GenerateQuadsBricks(gTextures['main'])
	}

	--initialize the virtual resolution
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false , 
		resizable = true
	})

	--setup sound effects, later we can just index the table and call each entry's play method
	gSounds = {

		['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
		['score'] = love.audio.newSource('sounds/score.wav', 'static'),
		['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
		['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
		['no-select'] = love.audio.newSource('sounds/no_select.wav', 'static'),
		['brick-hit-1'] = love.audio.newSource('sounds/brick_hit_1.wav', 'static'),
		['brick-hit-2'] = love.audio.newSource('sounds/brick_hit_2.wav', 'static'),
		['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
		['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
		['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
		['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

		['music'] = love.audio.newSource('sounds/music.wav', 'stream')
	}

	gStateMachine = StateMachine {
		['play'] = function() return PlayState() end,
		['start'] = function() return StartState() end
		
	}
	gStateMachine:change('start')

	--a table we will use to keep track of all keys pressed
	love.keyboard.keysPressed = {}

end

function love.resize(w,h)
	push:resize(w,h)
end

function love.update(dt)
	gStateMachine:update(dt)

	--gSounds['music']:play()
	
	--reset the keys pressed every frame
	love.keyboard.keysPressed = {}
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

function love.draw()

	--begin drawing with push in our virtual resolution
	push:apply('start')

	--background should be drawn regardless of state, scaled to fit our virtual resolution
	local backgroundWidth = gTextures['background']:getWidth()
	local backgroundHeight = gTextures['background']:getHeight()

	love.graphics.draw(gTextures['background'],
		--drqw at coordinates 0,0
		0, 0, 
		--no rotation
		0,
		--scale on the x and y axis so it fits the screen
		VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

	--use the state machine to defer rendering to the current state we're in
	gStateMachine:render()

	displayFPS()

	push:apply('end')
end

function displayFPS()
	--FPS display across all states
	love.graphics.setFont(gFonts['small'])
	love.graphics.setColor(0, 1, 1, 1)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end