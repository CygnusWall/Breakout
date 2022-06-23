LevelMaker = Class{}

function LevelMaker.createMap(level)
	local bricks = {}

	local numRows = math.random(1, 5)

	local numCols = math.random(7, 13)

	--lay out bricks so that they touch each other and fill the space
		for y = 1, numRows do
			for x = 1, numCols do
				b = Brick(
					--x coordinate
					(x-1)
					* 32 --multiply by 32 because that's the brick width
					+ 8  -- eight pixels of buffer
					+ (10 - numCols) * 16,

					--y coordinate
					y * 16

					)

					table.insert(bricks, b)
			end
		end
	return bricks
end