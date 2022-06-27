Hearts = Class{}

function Hearts:init()
	--position at top right of the screen
	self.x = VIRTUAL_WIDTH - 10
	self.y = 6

	self.hearts = 2
	self.hearts_lost = 0

	--1 being a full heart, 2 being an empty heart, bit unnescessary because the logic has changed, i'm leaving 
	--it in because putting 1 instead of the variable may be confusing to future readers(including me)
	self.status = 1


end

function Hearts:hit()
	gSounds['score']:play()
	self.hearts_lost = self.hearts_lost + 1
	--unnescessary here too, but yolo
	self.status = 2

end

function Hearts:render()
		
		--if the player has lost a heart, and they have not lost all(meaning they are dead) then do the following
		if self.hearts_lost > 0 then
			--for every heart lost draw it at the x and y pos of the furthest full heart, scaled by 12 pixels because that is the 
			--heart size
			for i = 0, self.hearts_lost do
				love.graphics.draw(gTextures['main'], gFrames['hearts'][self.status], self.x - self.hearts * 12 + i * 12, self.y)
			end
		end

		--only draw hearts that the player has remaining i.e hearts - hearts_lost = hearts remaining
		for i = 0, self.hearts - self.hearts_lost do
					love.graphics.draw(gTextures['main'], gFrames['hearts'][1], self.x - i * 12, self.y)
		end
end