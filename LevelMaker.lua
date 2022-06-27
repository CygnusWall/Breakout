LevelMaker = Class{}

function LevelMaker.createMap(level)
	local bricks = {}

	local numRows = --math.random(1, 5)
	10
	local numCols = --math.random(7, 13)
	13
	--lay out bricks so that they touch each other and fill the space
		for y = 5, numRows do
			for x = 1, numCols do
				b = Brick(
					--x coordinate
					(x-1)
					* 32 --multiply by 32 because that's the brick width
					+ 8  -- eight pixels of buffer
					+ (13 - numCols) * 16,

					--y coordinate
					y * 16

					)

					--insert b into the table of bricks
					table.insert(bricks, b)
			end
		end
	return bricks
end