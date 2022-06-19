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

	love.graphics.setFont(gfonts['small'])

	gTextures = {
		['background'] = love.graphics.newImage('graphics/background.png'),
		['main'] = love.graphics.newImage('graphics/breakout.png'),
		['arrows'] = love.graphics.newImage('graphics/arrows.png'),
		['hearts'] = love.graphics.newImage('graphics/hearts.png'),
		['particle'] = love.graphics.newImage('graphics/particle.png')
	}

	--initialize the virtual resolution
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false, 
		resizable = true
	})

	--setup sound effects, later we can just index the table and call each entry's play method
	gSounds = {

		['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav'),
		['score'] = love.audio.newSource('sounds/score.wav'),
		['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav'),
		['confirm'] = love.audio.newSource('sounds/confirm.wav'),
		['no-select'] = love.audio.newSource('sounds/no_select.wav'),
		['brick-hit-1'] = love.audio.newSource('sounds/brick_hit_1.wav'),
		['brick-hit-2'] = love.audio.newSource('sounds/brick_hit_2.wav'),
		['hurt'] = love.audio.newSource('sounds/hurt.wav'),
		['victory'] = love.audio.newSource('sounds/victory.wav'),
		['high-score'] = love.audio.newSource('sounds/high_score.wav'),
		['pause'] = love.audio.newSource('sounds/pause.wav'),

		['music'] = love.audio.newSource('sounds/music.wav')
	}

	gStateMachine = StateMachine {
		['start'] = function() return StartState() end
	}
	gStateMachine:change('start')

	--a table we will use to keep track of all keys pressed
	love.keyboard.keysPressed{}

end



