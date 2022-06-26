--takes in a large image and splits it into multiple evenly divided quads(smaller images with coordinates)
function GenerateQuads(atlas, tilewidth, tileheight)
	local sheetWidth = atlas:getWidth() / tilewidth
	local sheetHeight = atlas:getHeight() / tileheight

	local sheetCounter = 1
	local spritesheet = {}

		for y = 0, sheetHeight - 1 do
			for x = 0, sheetWidth - 1 do
				spritesheet[sheetCounter] = 
					love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth, tileheight, atlas:getDimensions())
				sheetCounter = sheetCounter + 1
			end
		end

	return spritesheet

end

function table.slice(tbl, first, last, step)
	local sliced = {}

	--for the first(parameter) or from the first index, till the last(parameter) or end of table, increment in step(parameter) or 1
	for i = first or 1, last or #tbl, step or 1 do
		sliced[#sliced+1] = tbl[i]
	end

	return sliced
end

function GenerateQuadsPaddles(atlas)
	local x = 0
	local y = 64

	local counter = 1 
	local quads = {}

		for i = 0, 3 do
			--smallest
			quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
			counter = counter + 1

			--medium
			quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
			counter = counter + 1

			--large
			quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
			counter = counter + 1

			--extra large
			quads[counter] = love.graphics.newQuad(x, y, 128, 16, atlas:getDimensions())
			counter = counter + 1

			--prepare x and y for the next set of paddles
			x = 0
			y = y + 32

		end
	return quads
end

function GenerateQuadsBalls(atlas)
	local x = 96
	local y = 48

	local counter = 1
	local quads = {}

		for i = 0, 3 do
			quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
			x = x + 8
			counter = counter + 1
		end

		x = 96
		y = 56

		for i = 0, 2 do
			quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
			x = x + 8
			counter = counter + 1
		end
	return quads
end

function GenerateQuadsBricks(atlas)
	--making use of the slice function
	return table.slice(GenerateQuads(atlas, 32, 16), 1, 21)

	--[[
	local x = 0
	local y = 0

	local counter = 1
	local quads = {}

		for i = 0, 2 do
			for i = 0, 5 do
				quads[counter] = love.graphics.newQuad(x, y, 32, 32, atlas:getDimensions())
				x = x + 32
				counter = counter + 1
			end
			x = 0
			y = y + 16
		end

		x = 0

		for i = 0, 2 do
			quads[counter] = love.graphics.newQuad(x, y, 32, 32, atlas:getDimensions())
			x = x + 32
		end
	return quads
end

]]--

end

function playSound(source)
	local clone = source:clone()
	clone:play()
end

function displayFPS()
	--FPS display across all states
	love.graphics.setFont(gFonts['small'])
	love.graphics.setColor(0, 1, 1, 1)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

