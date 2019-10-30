local Player = Object:extend()

Player.loadResources = function()
	Player.Image = love.graphics.newImage("resources/player.png")
	Player.ImageSize = Util.Size(Player.Image:getDimensions())
end

Player.FaceSize = 12
Player.Speed = 64
Player.SpeedRun = 96

function Player:new(id)
	self.id = id or false
	
	self.me = false
	self.photo = false
	
	self.pos = Util.Point()
end

-- Main Loop

function Player:draw(isClient)
	love.graphics.push()
	love.graphics.translate(self.pos.x, self.pos.y)
	
	if self.me then
		if not self.photo then
			self.photo = true
			network.async(function()
				self.photo = love.graphics.newImage(self.me.photoUrl)
			end)
		end
	end
	
	if isClient then
		love.graphics.setColor(0.5, 0.75, 1)
	else
		love.graphics.setColor(1, 1, 1)
	end
	love.graphics.draw(Player.Image, 0, 0, 0, 1, 1, Player.ImageSize.width / 2, Player.ImageSize.height)
	
	love.graphics.setColor(1, 1, 1)
	if self.photo and self.photo ~= true then
		love.graphics.draw(self.photo, -Player.FaceSize/2, 2 - Player.ImageSize.height, 0, Player.FaceSize / self.photo:getWidth(), Player.FaceSize / self.photo:getWidth())
	end
	
	love.graphics.pop()
end

function Player:move(moveDir, running, dt)
	Util.PointNormalize(moveDir)
	
	if moveDir.x ~= 0 then
		self.pos.x = self.pos.x + moveDir.x * (running and Player.SpeedRun or Player.Speed) * dt
	else
		self.pos.x = Util.round(self.pos.x)
	end
	if moveDir.y ~= 0 then
		self.pos.y = self.pos.y + moveDir.y * (running and Player.SpeedRun or Player.Speed) * dt
	else
		self.pos.y = Util.round(self.pos.y)
	end
	
	love.audio.setPosition(self.pos.x / UNIT_SIZE, self.pos.y / UNIT_SIZE, 0)
	love.audio.setVelocity(moveDir.x / UNIT_SIZE, moveDir.y / UNIT_SIZE, 0)
end

-- Data

function Player:clientSetUpData(home)
	home.pos = Util.Point(self.pos.x, self.pos.y)
end

function Player:clientUpdateData(home)
	home.pos.x = self.pos.x
	home.pos.y = self.pos.y
end

function Player:serverUpdateData(home)
	if not self.me then
		self.me = home.me
	end
	
	if home.pos then
		self.pos.x = home.pos.x
		self.pos.y = home.pos.y
	end
end

return Player
