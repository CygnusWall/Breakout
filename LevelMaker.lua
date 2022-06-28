LevelMaker = Class{}

function LevelMaker.createMap(level)
	local bricks = {}

	local numRows = --math.random(1, 5)
	5
	local numCols = --math.random(7, 13)
	13

	local skip = 1
	local alternate = 2

	--lay out bricks so that they touch each other and fill the space
		for y = 1, numRows, 1 do

			if skip == 1 then
				--skip = 2
				

				for x = 3, numCols, alternate do
					b = Brick(
						--x coordinate
						(x-1 * alternate)
						* 32 --multiply by 32 because that's the brick width
						+ 8  -- eight pixels of buffer
						+ (13 - numCols) * 16,

						--y coordinate
						y * 16

						)

						--insert b into the table of bricks
						table.insert(bricks, b)
						
						
						

				end
			skip = 2
				
			else
				for x = 1, numCols, alternate do
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
						
						
					skip = 1	

			end
			end

		end
	return bricks
end