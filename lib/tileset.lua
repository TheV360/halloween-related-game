local TileSet = Object:extend()

function TileSet:new(o)
	o = o or {}
	
	if not o.image then error("No image given to tileset! That's kinda important!") end
	self.image = o.image
	self.imageSize = Util.Size(self.image:getDimensions())
	
	if o.tileSize then
		if type(o.tileSize) == "number" then
			self.tileSize = Util.Size(o.tileSize)
		elseif type(o.tileSize) == "table" then
			self.tileSize = Util.Size(o.tileSize.width, o.tileSize.height)
		else
			error("TileSize must be number or Util.Size")
		end
	else
		self.tileSize = Util.Size(math.min(self.imageSize.width, self.imageSize.height))
	end
	self.tileLength = Util.Size(math.floor(self.imageSize.width / self.tileSize.width), math.floor(self.imageSize.height / self.tileSize.height))
	self.tileTotal = self.tileLength.width * self.tileLength.height
	
	self.spriteBatch = love.graphics.newSpriteBatch(self.image)
	self.quads = {}
	
	local a = 0
	for y = 0, self.tileLength.height - 1 do
		for x = 0, self.tileLength.width - 1 do
			self.quads[a] = love.graphics.newQuad(
				x * self.tileSize.width,
				y * self.tileSize.height,
				self.tileSize.width,
				self.tileSize.height,
				self.imageSize.width,
				self.imageSize.height
			)
			a = a + 1
		end
	end
end

function TileSet:spr_add(quad, x, y, r, sx, sy, ox, oy, kx, ky)
	self.spriteBatch:add(self.quads[quad], x, y, r, sx, sy, ox, oy, kx, ky)
end
function TileSet:spr_addAligned(quad, x, y, r, sx, sy, ox, oy, kx, ky)
	self.spriteBatch:add(self.quads[quad], x * self.tileSize.width, y * self.tileSize.height, r, sx, sy, ox, oy, kx, ky)
end

return TileSet
