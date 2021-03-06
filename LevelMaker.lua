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
	local chosenCol = 1
	local chosenTier = 1


	local bricks = {}

	local numRows = math.random(1, 5)
	--5
	local numCols = math.random(7, 13)
	--local chosenCol = 1
	--local chosenTier = 1

	local highestTier = math.min(4, level % 4 + 1)

	local highestColor = math.min(5, level % 5 + 1)


	--lay out bricks so that they touch each other and fill the space
		for y = 1, numRows do

				

			--if we want to enable skipping for this row, it's a coin flip
			local skipPattern = math.random(1, 2) == 1 and true or false

			--if we want to enable alternating colors for this row, coin flip aswell
			local alternatePattern = math.random(1, 2) == 1 and true or false

			--choose colors to alternate between
			local altCol1 = math.random(1, highestColor)
			local altCol2 = math.random(1, highestColor)
			local altTier1 = math.random(1, highestTier)
			local altTier2 = math.random(1, highestTier)

			--used for skipping a block
			local skipFlag = math.random(1, 2) == 1 and true or false
			--used for alternating a block
			local alternateFlag = math.random(1, 2) == 1 and true or false

			--if we're not skipping or alternating use this color
			local solidColor = math.random(1, highestColor)
			local solidTier = math.random(1, highestTier)


				for x = 1, numCols do

					if skipPattern and skipFlag then
						--turn skipping off for next iteration
						skipFlag = not skipFlag
					

						--workaround of the continue statement in lua
						goto continue
					else
					--if the flag is unused in this iteration flip it for the next one
						--
						skipFlag = not skipFlag
					end



					

					
					--if we're alternating find out which color and tier to use
					if alternatePattern and alternateFlag then
						chosenCol = 1
						chosenTier = 1
				 		--flip the flag
				 		altternateFlag = not alternateFlag
				 	else
				 		chosenCol = 4
				 		chosenTier = 4
				 		--flip the flag again so the pattern continues
				 		alternateFlag = not alternateFlag
				 	end

				 	--may be unnecessary
				 	if not alternatePattern then
                		chosenCol = solidColor
                		chosenTier = solidTier
            		end 

				 	b = Brick(
						--x coordinate
						(x-1)
						* 32 --multiply by 32 because that's the brick width
						+ 8  -- eight pixels of buffer
						+ (13 - numCols) * 16,

						--y coordinate
						y * 16,

						chosenCol,

						chosenTier

						)

						

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