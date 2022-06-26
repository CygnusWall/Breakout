Hearts = Class{}

function Hearts:init()
	self.x = VIRTUAL_WIDTH - 10
	self.y = 8

	self.hearts = 3
	self.status = 1


end

function Hearts:update(dt)

end

function Hearts:hit()
	gSounds['recover']:play()
end

function Hearts:render()
	for i = 1, self.hearts do
		love.graphics.draw(gTextures['main'], gFrames['hearts'][self.status], self.x - i * 12, self.y)
	end
end