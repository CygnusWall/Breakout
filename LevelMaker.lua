--used to make the map a certain shape
	NONE = 1
	SINGLE_PYRMID = 2
	MULTI_PYRMID = 3

	--per row patterns
	SOLID = 1 --makes everything the same color
	ALTERNATE = 2 --alternate colors
	SKIP = 3 --skip every other block
	NONE = 4 --no blocks for this row


LevelMaker = Class{}

function LevelMaker:init()


end

function LevelMaker:createMap(level)


	local bricks = {}

	local numRows = --math.random(1, 5)
	5
	local numCols = --math.random(7, 13)
	13

	local highestTier = math.floor(level/5)

	local highestColor = math.min(5, level % 5 + 1)


	--lay out bricks so that they touch each other and fill the space
		for y = 1, numRows, 1 do

			--if we want to enable skipping for this row, it's a coin flip
			local skipPattern = 2--math.random(1, 2) == 1 and true or false

			--if we want to enable alternating colors for this row, coin flip aswell
			local alternatePattern = 1--math.random(1, 2) == 1 and true or false

			--choose colors to alternate between
			local altCol1 = math.random(1, highestColor)
			local altCol2 = math.random(1, highestColor)
			local altTier1 = math.random(0, highestTier)
			local altTier2 = math.random(0, highestTier)

			--used for skipping a block
			local skipFlag = 2--math.random(2) == 1 and true or false
			--used for alternating a block
			local alternateFlag = math.random(2) == 1 and true or false

			--if we're not skipping or alternating use this color
			local solidColor = math.random(1, highestColor)
			local solidTier = math.random(0, highestTier)


				for x = 1, numCols do

					if skipPattern and skipFlag then
						--turn skipping off for next iteration
						skipFlag = not skipFlag
					

						--workaround of the continue statement in lua
						goto continue
					else
					--if the flag is unused in this iteration flip it for the next one
						--skipFlag = not skipFlag
					end



					b = Brick(
						--x coordinate
						(x-1)
						* 32 --multiply by 32 because that's the brick width
						+ 8  -- eight pixels of buffer
						+ (13 - numCols) * 16,

						--y coordinate
						y * 16,

						1,

						3

						)

						--b.color = 1

					--[[
					--if we're alternating find out which color and tier to use
					if alternatePattern and alternateFlag then
						b.tru_color = altCol1
						b.tier = altTier1
				 		--flip the flag
				 		altternateFlag = not alternateFlag
				 	else
				 		b.tru_color = altCol2
				 		b.tier = altTier2
				 		--flip the flag again so the pattern continues
				 		alternateFlag = not alternateFlag
				 	end

				 	--if this code is reached it means we're not alternating so use the solid color and solid tier
				 	--[[if not alternatePattern then
				 		b.tru_color = solidColor
				 		b.tier = solidTier
				 	end]]--

					--insert b into the table of bricks
					table.insert(bricks, b)
						
					--lua's version of the continue statement
					::continue::

				end

		end

		if #bricks == 0 then
			return self.createMap(level)
		else
			return bricks
		end
end