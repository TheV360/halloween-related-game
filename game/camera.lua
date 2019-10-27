local Camera = {}

Camera.Margin = 32

function Camera.new(thing)
	local c = {}
	
	c.following = thing
	c.pos = Util.Point(thing.pos.x or 0, thing.pos.y or 0)
	
	Camera.update(c)
	
	return c
end

function Camera.update(c)
	local dx = c.following.pos.x - c.pos.x
	local dy = c.following.pos.y - c.pos.y
	if math.abs(dx) > Camera.Margin then
		if dx > 0 then
			c.pos.x = c.pos.x + math.abs(dx - Camera.Margin)
		else
			c.pos.x = c.pos.x - math.abs(dx + Camera.Margin)
		end
	end
	if math.abs(dy) > Camera.Margin then
		if dy > 0 then
			c.pos.y = c.pos.y + math.abs(dy - Camera.Margin)
		else
			c.pos.y = c.pos.y - math.abs(dy + Camera.Margin)
		end
	end
end

return Camera
