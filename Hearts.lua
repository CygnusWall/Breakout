Hearts = Class{}

function Hearts:init()
	self.x = VIRTUAL_WIDTH - 10
	self.y = 6

	self.hearts = 2
	self.hearts_lost = 0
	self.status = 1


end

function Hearts:update(dt)

end

function Hearts:hit()
	gSounds['score']:play()
	self.hearts_lost = self.hearts_lost + 1
	self.status = 2

end

function Hearts:render()
		

		if self.hearts_lost > 0 and self.hearts_lost < 4 then
			for i = 0, self.hearts_lost do
				love.graphics.draw(gTextures['main'], gFrames['hearts'][self.status], self.x - 24 + i * 12, self.y)
			end
		else
			
		end

		for i = 0, self.hearts - self.hearts_lost do
			--for i = 0, self.hearts do
					love.graphics.draw(gTextures['main'], gFrames['hearts'][1], self.x - i * 12, self.y)
			--end
		end
end