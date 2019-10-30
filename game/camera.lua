local Camera = Object:extend()

Camera.Margin = 32

function Camera:new(thing)
	self.following = thing
	self.pos = Util.Point(thing.pos.x or 0, thing.pos.y or 0)
	
	Camera.update(self)
end

function Camera:update()
	local dx = self.following.pos.x - self.pos.x
	local dy = self.following.pos.y - self.pos.y
	if math.abs(dx) > Camera.Margin then
		if dx > 0 then
			self.pos.x = self.pos.x + math.abs(dx - Camera.Margin)
		else
			self.pos.x = self.pos.x - math.abs(dx + Camera.Margin)
		end
	end
	if math.abs(dy) > Camera.Margin then
		if dy > 0 then
			self.pos.y = self.pos.y + math.abs(dy - Camera.Margin)
		else
			self.pos.y = self.pos.y - math.abs(dy + Camera.Margin)
		end
	end
end

return Camera
